(define (problem PDDL_Q1_1) 

    (:domain Warehouse_No_Belt)
    (:objects 
        l1 l2 l3 l4 l5 - location
        r1 r2 - robot
        p1 p2 p3 p4 - package
    )

    (:init
        (connected l1 l2)
        (connected l2 l1)
        (connected l2 l3)
        (connected l3 l2)
        (connected l2 l4)
        (connected l4 l2)
        (connected l3 l5)
        (connected l5 l3)

        (robot-at r1 l1)
        (robot-at r2 l4)

        (package-at p1 l1)
        (package-at p2 l2)
        (package-at p3 l3)
        (package-at p4 l4)

        (handempty r1)
        (handempty r2)
    )

    (:goal (and
        (package-at p1 l5)
        (package-at p2 l5)
        (package-at p3 l5)
        (package-at p4 l5)
    ))

)
