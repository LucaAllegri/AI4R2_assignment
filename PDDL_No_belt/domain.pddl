;Header and description

(define (domain Warehouse_No_Belt)

    ;remove requirements that are not needed
    (:requirements :strips :typing)

    (:types
        location
        robot
        package    
    )

    (:predicates 
        (connected ?from - location ?to - location)
        (robot-at ?r - robot ?l - location)
        (package-at ?p - package ?l - location)
        (holding ?r - robot ?p - package)
        (handempty ?r - robot)
    )


    (:functions ;todo: define numeric functions here
    )

    (:action pick
        :parameters (?p - package ?r - robot ?l - location)
        :precondition (and (handempty ?r)
                           (robot-at ?r ?l)
                           (package-at ?p ?l)                             
                      )
        :effect (and (not (handempty ?r))
                     (holding ?r ?p)
                     (not (package-at ?p ?l))
                )
    )

    (:action place
        :parameters (?p - package ?r - robot ?l - location)
        :precondition (and (holding ?r ?p)
                           (robot-at ?r ?l)
                      )
        :effect (and (handempty ?r)
                     (not (holding ?r ?p))
                     (package-at ?p ?l)
                )
    )

    (:action move
        :parameters (?r - robot ?from ?to - location)
        :precondition (and (connected ?from ?to)
                           (robot-at ?r ?from)
                      )
        :effect (and (not (robot-at ?r ?from))
                     (robot-at ?r ?to)
                )
    )
)