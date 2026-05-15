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

        ;; automatic connection between conveyors: if the exit of a conveyor is in the same location of the entry of another conveyor, then they are connected
        (conveyor-connected ?c1 - conveyor ?c2 - conveyor ?l1 - location ?l2 - location)
        
        ;; robot state
        (robot-at ?r - robot ?l - location)
        (robot-act-on ?r - robot ?l - location)
        (holding ?r - robot ?p - package)
        (handempty ?r - robot)

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
                           (on-belt      ?p ?c)
                           (conveyor-exit ?c ?l)                  
        )
        :effect (and (holding ?r ?p)
                     (not (package-at ?p ?l))
                     (not (handempty ?r))
                     (not (on-belt ?p ?c))
                     (belt-free ?l)
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
        )
        :effect (and (not (holding ?r ?p))
                     (package-at ?p ?l)
                     (on-belt ?p ?c)
                     (handempty ?r)
                     (not (belt-free ?l))
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
        )
        :effect (and (holding ?r ?p)
                     (not (package-at ?p ?l))
                     (not (handempty ?r))
                     (not (on-belt ?p ?c))
                     (belt-free ?l)
                     (increase (total-cost) 1)
        )
    )

    (:action deliver
        :parameters (?r - robot ?p - package ?l - location)
        :precondition (and (robot-at ?r ?l)
                           (robot-act-on ?r ?l)
                           (holding ?r ?p)
                           (delivery-zone ?l)
        )
        :effect (and (not (holding ?r ?p))
                     (package-at ?p ?l)
                     (handempty ?r)
                     (increase (total-cost) 1)
        )
    )
    
    ;; ROBOT change from a configuration to another one
    (:action manipulate
        :parameters (?r - robot ?from ?to - location)
        :precondition (and (robot-at ?r ?from)
                           (robot-act-on ?r ?from)
                           (robot-act-on ?r ?to)
                           (not (= ?from ?to))
        )
        :effect (and (robot-at ?r ?to)
                     (not (robot-at ?r ?from))
                     (increase (total-cost) 4)
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

    ;; event: when the progess is higher than 1.0, the package pass from a segment to another one. It is not for the last segment of the conveyor
    (:event advance-segment
        :parameters (?p - package ?c - conveyor ?l1 - location ?l2 - location)
        :precondition (and (on-belt ?p ?c)
                           (package-at ?p ?l1)
                           (belt-segment ?c ?l1 ?l2)
                           (belt-free ?l2)
                           (>= (belt-progress ?p) 1.0)
                           (not (conveyor-exit ?c ?l1))
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
                     (assign (belt-progress ?p) 0)
        )
    )
)
