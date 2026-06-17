(define (domain PDDL_Warehouse_Conveyor)

    ;remove requirements that are not needed
    (:requirements :strips :typing :negative-preconditions :action-costs)

    (:types
        location
        robot
        package    
    )

    (:predicates 
        (connected ?from - location ?to - location)
        (belt-connected ?from - location ?to - location)
        (robot-at ?r - robot ?l - location)
        (package-at ?p - package ?l - location)
        (holding ?r - robot ?p - package)
        (handempty ?r - robot)
        (on-belt ?p - package)
        (load-zone ?l - location)
        (unload-zone ?l - location)
        (delivery-zone ?l - location)
        (belt-free ?l - location)
    )

    (:functions
        (total-cost)
    )

    (:action move
        :parameters (?r - robot ?from ?to - location)
        :precondition (and (connected ?from ?to)
                           (robot-at ?r ?from)
                      )
        :effect (and (not (robot-at ?r ?from))
                     (robot-at ?r ?to)
                     (increase (total-cost) 4)
                )
    )

    (:action pick
        :parameters (?p - package ?r - robot ?l - location)
        :precondition (and (handempty ?r)
                           (robot-at ?r ?l)
                           (package-at ?p ?l)        
                           (not (on-belt ?p))
                           (unload-zone ?l)                     
                      )
        :effect (and (not (handempty ?r))
                     (holding ?r ?p)
                     (not (package-at ?p ?l))
                     (increase (total-cost) 1)
                )
    )

    (:action place
        :parameters (?p - package ?r - robot ?l - location)
        :precondition (and (holding ?r ?p)
                           (robot-at ?r ?l)
                           (delivery-zone ?l)
                      )
        :effect (and (handempty ?r)
                     (not (holding ?r ?p))
                     (package-at ?p ?l)
                     (increase (total-cost) 1)
                )
    )

    (:action load-conveyor
        :parameters (?r - robot ?p - package ?l - location)
        :precondition (and (robot-at ?r ?l)
                           (load-zone ?l)
                           (holding ?r ?p)
                           (belt-free ?l)
                     )
        :effect (and (package-at ?p ?l)
                     (on-belt ?p)
                     (handempty ?r)
                     (not (holding ?r ?p))
                     (not (belt-free ?l))
                     (increase (total-cost) 1)
                )
    )

    (:action conveyor-step
        :parameters (?p - package ?from ?to - location)
        :precondition (and (on-belt ?p)
                           (package-at ?p ?from)
                           (belt-connected ?from ?to)
                           (belt-free ?to)
                      )
        :effect (and (not (package-at ?p ?from))
                     (package-at ?p ?to)
                     (not (belt-free ?to))
                     (belt-free ?from)
                     (increase (total-cost) 0)
                )
    )

    (:action retrieve
        :parameters (?r - robot ?p - package ?l - location)
        :precondition (and (robot-at ?r ?l)
                           (package-at ?p ?l)
                           (on-belt ?p)
                           (handempty ?r)
                           (unload-zone ?l)
                      )
        :effect (and (holding ?r ?p)
                     (not (package-at ?p ?l))
                     (not (on-belt ?p))
                     (not (handempty ?r))
                     (belt-free ?l)
                     (increase (total-cost) 1)
                )
    )

)