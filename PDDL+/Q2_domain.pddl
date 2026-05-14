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

    ;: ROBOT1 PICK FROM STORAGE2 
    (:action pick-from-storage
        :parameters (?r - robot ?pck - package ?l - location)
        :precondition (and (robot-at ?r ?l)
                           (robot-act-on ?r ?l)
                           (package-at ?pck ?l)
                           (handempty ?r)
                           (unload-zone ?l)
                           (not (exists (?c - conveyor) (on-belt ?pck ?c)))
        )
        :effect (and (holding ?r ?pck)
                     (not (package-at ?pck ?l))
                     (not (handempty ?r))
                     (increase (total-cost) 1)
        )
            
    )

    ;; ROBOT2to7 retrive packages moving on the belt
    (:action retrieve
        :parameters (?r - robot ?pck - package ?l - location ?c - conveyor)
        :precondition (and (robot-at ?r ?l)
                           (robot-act-on ?r ?l)
                           (package-at ?pck ?l)
                           (on-belt ?pck ?c)
                           (handempty ?r)
                           (unload-zone ?l)
        )
        :effect (and (holding ?r ?pck)
                     (not (package-at ?pck ?l))
                     (not (handempty ?r))
                     (not (on-belt ?pck ?c))
                     (belt-free ?l)
                     (increase (total-cost) 1)
        )
    )


    ;; ROBOT change from a configuration to another one
    ;(:action manipulate
    ;    :parameters (?r - robot ?pck - package ?from ?to - location)
    ;    :precondition (and (robot-at ?r ?from)
    ;                       (holding ?r ?pck)
    ;                       (robot-act-on ?r ?to)
    ;    )
    ;    :effect (and (robot-at ?r ?to)
    ;                 (not (robot-at ?r ?from))
    ;                 (not (handempty ?r))
    ;                 (holding ?r ?pck)              
    ;    )
    ;)  

    ;; Robot load the conveyor with a package into the load-zone
    (:action load-conveyor
        :parameters (?r - robot ?pck - package ?from ?to - location ?c - conveyor)
        :precondition (and (robot-at ?r ?from)
                           (robot-act-on ?r ?from)
                           (robot-act-on ?r ?to)
                           (holding ?r ?pck)
                           (belt-free ?to)
                           (load-zone ?to)
                           (conveyor-entry ?c ?to)
                           (belt-running ?c)
        )
        :effect (and (not (holding ?r ?pck))
                     (package-at ?pck ?to)
                     (on-belt ?pck ?c)
                     (handempty ?r)
                     (not (belt-free ?to))
                     (assign (belt-progress ?pck) 0.0)
                     (increase (total-cost) 1)
        )
    )

    ;; Robot deliver the package into the correct delivery zone
    (:action deliver
    :parameters (?r - robot ?pck - package ?l-robot - location ?l-dest - location)
    :precondition (and (robot-at ?r ?l-robot)
                       (robot-act-on ?r ?l-robot)
                       (holding ?r ?pck)
                       (delivery-zone ?l-dest)
    )
    :effect (and (not (holding ?r ?pck))
                 (package-at ?pck ?l-dest)
                 (handempty ?r)
                 (increase (total-cost) 1)
    )
)

    ;(:process conveyor-motion
    ;    :parameters (?c - conveyor)
    ;    :precondition (belt-running ?c)
    ;    :effect (and 
    ;        ;(increase (belt-displacement ?c) (* #t (conveyor-speed ?c)))
    ;        (increase (total-cost) (* #t 0.1)) 
    ;    )
    ;)

    ;;continuous movement of the package 
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
