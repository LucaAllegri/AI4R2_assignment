(define (domain PDDL_plus_Warehouse_Conveyor)

    (:requirements  
        :fluents 
        :typing
        :negative-preconditions
        :adl
        :strips
        :time
        :action-costs
    )

    (:types 
        robot
        location
        package
        conveyor
    )

    (:predicates 

        ;; belt 
        (belt-segment ?c - conveyor ?from - location ?to - location)
        (conveyor-entry ?c - conveyor ?l - location)
        (conveyor-exit ?c - conveyor ?l - location)
        (belt-free ?l - location)
        (belt-running ?c - conveyor)
        (conveyor-connected ?c1 - conveyor ?c2 - conveyor ?l1 - location ?l2 - location)
        
        ;; robot state
        (robot-at ?r - robot ?l - location)
        (robot-act-on ?r - robot ?l - location)
        (holding ?r - robot ?p - package)
        (handempty ?r - robot)
        (busy ?r - robot)

        ;; package state
        (package-at ?p - package ?l - location)
        (on-belt ?p - package ?c - conveyor)

        ;; zones
        (load-zone ?l - location)
        (unload-zone ?l - location)
        (delivery-zone ?l - location)    
    )


    (:functions 
        (belt-progress ?p - package) 
        (conveyor-speed ?c - conveyor)     
        (busy-timer ?r - robot)
        (total-cost)
    )

    ;; GRASP from the last location of the main conveyor (storage2)
    (:action grasp
        :parameters (?r - robot ?p - package ?l - location ?c - conveyor)
        :precondition (and (robot-at ?r ?l)
                           (robot-act-on ?r ?l)
                           (package-at ?p ?l)
                           (handempty ?r)
                           (unload-zone ?l)
                           (on-belt ?p ?c)
                           (conveyor-exit ?c ?l)
                           (not (busy ?r))
        )
        :effect (and (holding ?r ?p)
                     (not (package-at ?p ?l))
                     (not (handempty ?r))
                     (not (on-belt ?p ?c))
                     (belt-free ?l)
                     (busy ?r)
                     (assign (busy-timer ?r) 0.5)
                     (increase (total-cost) 1)
        )
    )

    ;; action for the robot1 to load-conveyor Right or Left
    (:action load-conveyor
        :parameters (?r - robot ?p - package ?l - location ?c - conveyor)
        :precondition (and (robot-at ?r ?l)
                           (robot-act-on ?r ?l)
                           (holding ?r ?p)
                           (belt-free ?l)
                           (load-zone ?l)
                           (conveyor-entry ?c ?l)
                           (belt-running ?c)
                           (busy ?r)
                           (<= (busy-timer ?r) 0.0)
        )
        :effect (and (not (holding ?r ?p))
                     (package-at ?p ?l)
                     (on-belt ?p ?c)
                     (handempty ?r)
                     (not (belt-free ?l))
                     (not (busy ?r))
                     (assign (busy-timer ?r) 0.5)
                     (assign (belt-progress ?p) 0.0)
                     (increase (total-cost) 1)
        )
    )

    ;; ROBOT2to7 INTERCEPT a package that is running on the belt
    (:action intercept
        :parameters (?r - robot ?p - package ?l - location ?c - conveyor)
        :precondition (and (robot-at ?r ?l)
                           (robot-act-on ?r ?l)
                           (package-at ?p ?l)
                           (on-belt ?p ?c)
                           (handempty ?r)
                           (unload-zone ?l)
                           (not (conveyor-exit  ?c ?l))
                           (not (conveyor-entry ?c ?l))
                           (not (busy ?r))
        )
        :effect (and (holding ?r ?p)
                     (not (package-at ?p ?l))
                     (not (handempty ?r))
                     (not (on-belt ?p ?c))
                     (belt-free ?l)
                     (busy ?r)
                     (assign (busy-timer ?r) 0.5)
                     (increase (total-cost) 1)
        )
    )
    
    ;; ROBOT2to7 DELIVER a package from unload zone to a delivery zone
    (:action deliver
        :parameters (?r - robot ?p - package ?l - location)
        :precondition (and (robot-at ?r ?l)
                           (robot-act-on ?r ?l)
                           (holding ?r ?p)
                           (delivery-zone ?l)
                           (busy ?r)
                           (<= (busy-timer ?r) 0.0)
        )
        :effect (and (not (holding ?r ?p))
                     (package-at ?p ?l)
                     (handempty ?r)
                     (not (busy ?r))
                     (assign (busy-timer ?r) 0.5)
                     (increase (total-cost) 1)
        )
    )
    
    ;; ROBOT change from a configuration to another one
    (:action manipulate-with-package
        :parameters (?r - robot ?p - package ?from ?to - location)
        :precondition (and (robot-at ?r ?from)
                           (robot-act-on ?r ?from)
                           (robot-act-on ?r ?to)
                           (holding ?r ?p)
                           (not (= ?from ?to))
                           (busy ?r)
                           (<= (busy-timer ?r) 0.0)
                           (or (delivery-zone ?to) (load-zone ?to))
        )
        :effect (and (robot-at ?r ?to)
                     (not (robot-at ?r ?from))
                     (holding ?r ?p)
                     (busy ?r)
                     (assign (busy-timer ?r) 2.0)
                     (increase (total-cost) 15)
        )
    )

    (:action manipulate-no-package
        :parameters (?r - robot ?from ?to - location)
        :precondition (and (robot-at ?r ?from)
                           (robot-act-on ?r ?from)
                           (robot-act-on ?r ?to)
                           (not (= ?from ?to))
                           (not (busy ?r))
                           (handempty ?r)
                           (or (unload-zone ?to) (load-zone ?to))
                           (exists (?p - package) 
                               (and (package-at ?p ?to) (not (holding ?r ?p)))
                           )
        )
        :effect (and (robot-at ?r ?to)
                     (not (robot-at ?r ?from))
                     (busy ?r)
                     (assign (busy-timer ?r) 2.0)
                     (increase (total-cost) 15)
        )
    )

    ;; continuous movement of the package 
    (:process package-movement
        :parameters (?p - package ?c - conveyor)
        :precondition (and (on-belt ?p ?c) 
                           (belt-running ?c)
                           (< (belt-progress ?p) 1.0)
                      )
        :effect (increase (belt-progress ?p) (* #t (conveyor-speed ?c)))
    )

    (:process robot-timers
        :parameters (?r - robot)
        :precondition (> (busy-timer ?r) 0.0)
        :effect (decrease (busy-timer ?r) (* #t 1.0))
    )

    (:event free-robot
        :parameters (?r - robot)
        :precondition (and (busy  ?r)
                           (<= (busy-timer ?r) 0.0)
                           (handempty ?r)
                      )
        :effect (and (not (busy ?r)))
    )

    ;; event: when the progess is higher than 1.0, the package pass from a segment to another one. It is not for the last segment of the conveyor
    (:event advance-segment
        :parameters (?p - package ?c - conveyor ?l1 - location ?l2 - location)
        :precondition (and (on-belt ?p ?c)
                           (package-at ?p ?l1)
                           (belt-segment ?c ?l1 ?l2)
                           (belt-free ?l2)
                           (not (conveyor-exit ?c ?l1))
                           (>= (belt-progress ?p) 1.0)
        )
        :effect (and (not (package-at ?p ?l1))
                     (package-at ?p ?l2)
                     (belt-free ?l1)
                     (not (belt-free ?l2))
                     (assign (belt-progress ?p) 0.0)
        )
    )

    (:event reach-exit
        :parameters (?p - package ?cFrom ?cTo - conveyor ?from ?to - location)
        :precondition (and (on-belt ?p ?cFrom)
                           (package-at ?p ?from)
                           (conveyor-exit ?cFrom ?from)
                           (conveyor-entry ?cTo ?to)
                           (conveyor-connected ?cFrom ?cTo ?from ?to)
                           (belt-free ?to)
                           (>= (belt-progress ?p) 1.0)
        )
        :effect (and (not (package-at ?p ?from))
                     (package-at ?p ?to)
                     (not (on-belt ?p ?cFrom))
                     (on-belt ?p ?cTo)
                     (belt-free ?from)
                     (not (belt-free ?to))
                     (assign (belt-progress ?p) 0.0)
        )
    )
)
