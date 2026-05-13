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
        (belt-segment ?c - conveyor ?from - location ?to - location)

        (conveyor-entry ?c - conveyor ?l - location)
        (conveyor-exit ?c - conveyor ?l - location)

        (robot-at ?r - robot ?l - location)
        (robot-act-on ?r -robot ?l - location) 
        (holding ?r - robot ?p - package)
        (handempty ?r - robot)

        (package-at ?p - package ?l - location)
        (on-belt ?p - package ?c - conveyor)
        (package-ready ?p - package)

        (package-conveyor ?p - package ?c - conveyor)

        (load-zone ?l - location)
        (unload-zone ?l - location)
        (delivery-zone ?l - location)       
        
        (serves ?l-out - location ?l-in - location)

        (belt-free ?l - location)
        (belt-running ?c - conveyor)
        (belt-displacement ?c - conveyor)
    )


    (:functions 
       (belt-progress ?p - package)
        (conveyor-speed ?c - conveyor)
        (total-cost)
    )

    (:action pick-up
        :parameters (?r - robot ?pck - package ?l - location ?c - conveyor)
        :precondition (and 
            (robot-at ?r ?l)
            (conveyor-exit ?c ?l)
            (package-at ?pck ?l)
            (handempty ?r)
            (unload-zone ?l)
        )
        :effect (and
            (holding ?r ?pck)
            (not (package-at ?pck ?l))
            (not (handempty ?r))
            (increase (total-cost) 1)
        )
            
    )

    (:action deliver
        :parameters (?r - robot ?pck - package ?from ?to - location ?c - conveyor)
        :precondition (and
            (robot-at ?r ?from)
            (holding ?r ?pck)
            (serves ?from ?to)
            (delivery-zone ?to)
        )
        :effect (and
            (not (holding ?r ?pck))
            (package-at ?pck ?to)
            (handempty ?r)
            (increase (total-cost) 1)
        )
    )

    (:action load-conveyor
        :parameters (?r - robot ?pck - package ?from ?to - location ?cfrom ?cto - conveyor)
        :precondition (and
            (robot-at ?r ?from)
            (holding ?r ?pck)
            (conveyor-exit ?cfrom ?from)
            (conveyor-entry ?cto ?to)
            (belt-free ?to)
        )
        :effect (and
            (not (holding ?r ?pck))
            (package-conveyor ?pck ?cto)
            (on-belt ?pck ?cto)
            (not (belt-free ?to))
            (handempty ?r)
            (assign (belt-progress ?pck) 0)
            (increase (total-cost) 1)
        )
    )

    (:process conveyor-motion
        :parameters (?c - conveyor)
        :precondition (belt-running ?c)
        :effect (and 
            (increase (belt-displacement ?c) (* #t (conveyor-speed ?c)))
            (increase (total-cost) (* #t 0.1)) 
        )
    )

    (:process package-movement
        :parameters (?p - package ?c - conveyor)
        :precondition (and (on-belt ?p ?c) 
                           (belt-running ?c)
                      )
        :effect (increase (belt-progress ?p) (* #t (conveyor-speed ?c)))
    )

    ;; event: when the progess is higher than 1.0, the package pass from a segment to another one
    (:event advance-segment
        :parameters (?p - package ?c - conveyor ?l1 - location ?l2 - location)
        :precondition (and 
            (on-belt ?p ?c)
            (package-at ?p ?l1)
            (belt-segment ?c ?l1 ?l2)
            (belt-free ?l2)
            (>= (belt-progress ?p) 1.0)
        )
        :effect (and 
            (not (package-at ?p ?l1))
            (package-at ?p ?l2)
            (belt-free ?l1)
            (not (belt-free ?l2))
            (assign (belt-progress ?p) 0)
        )
    )

    (:event reach-exit
        :parameters (?p - package ?cfrom ?cto - conveyor ?from ?to - location)
        :precondition (and 
            (on-belt ?p ?cfrom)
            (package-at ?p ?from)
            (conveyor-exit ?cfrom ?from)
            (conveyor-entry ?cto ?to)
            (>= (belt-progress ?p) 1.0)
        )
        :effect (and 
            (not (on-belt ?p ?cfrom))
            (on-belt ?p ?cto)
            (package-at ?p ?to)
        )
    )
    
    

)
