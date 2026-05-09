(define (problem PDDL_Q1_NECESSARY)

    (:domain PDDL_Warehouse_Conveyor)

    (:objects
        storage1 storage2 storage3 storage4 - location
        
        l1 l2 l7 l8
        l3 l9
        l4 l5 l10 l11
        l6 l12 - location

        delivery1 delivery2 delivery3 delivery4 - location

        r1 r2 - robot

        pck1 pck2 - package
    )

    (:init

        ;; first row of the grid
        (connected storage1 l1)
        (connected l1 storage1)
        (connected l1 l2)
        (connected l2 l1)
        (connected l7 l8)
        (connected l8 delivery1)
        (connected delivery1 l8)

        ;; second row of the grid
        (connected storage2 l3)
        (connected l3 storage2)
        (connected l3 l2)
        (connected l2 l3)
        (connected l7 l9)
        (connected l9 l7)
        (connected l9 delivery2)
        (connected delivery2 l9)

        ;; third row of the grid
        (connected storage3 l4)
        (connected l4 storage3)
        (connected l4 l5)
        (connected l5 l4)
        (connected l10 l11)
        (connected l11 l10)
        (connected l11 delivery3)
        (connected delivery3 l11)

        ;; fourth row of the grid
        (connected storage4 l4)
        (connected l4 storage4)
        (connected l4 l6)
        (connected l6 l4)
        (connected l10 l12)
        (connected l12 l10)
        (connected l12 delivery4)
        (connected delivery4 l12)

        ;;first column of the grid
        (connected storage1 storage2)
        (connected storage2 storage1)
        (connected storage2 storage3)
        (connected storage3 storage2)
        (connected storage3 storage4)
        (connected storage4 storage3)

        ;;second column of the grid
        (connected l1 l3)
        (connected l3 l1)
        (connected l3 l4)
        (connected l4 l3)

        ;;third column of the grid
        (connected l2 l5)
        (connected l5 l2)

        ;;fourth column of the grid
        (connected l7 l10)
        (connected l10 l7)

        ;;fifth column of the grid
        (connected l8 l9)
        (connected l9 l8)
        (connected l9 l11)
        (connected l11 l9)
        (connected l11 l12)
        (connected l12 l11)

        ;;sixth column of the grid
        (connected delivery1 delivery2)
        (connected delivery2 delivery1)
        (connected delivery2 delivery3)
        (connected delivery3 delivery2)
        (connected delivery3 delivery4)
        (connected delivery4 delivery3)

        ;; TOP CONVEYOR BELT
        (belt-connected l2 l7)

        ;; BOTTOM CONVEYOR BELT
        (belt-connected l4 l5)
        (belt-connected l4 l6)
        (belt-connected l5 l10)
        (belt-connected l6 l10)

        ;;LOAD ZONES
        (load-zone l2)
        (load-zone l4)
        
        ;;UNLOAD ZONES
        (unload-zone storage1)
        (unload-zone storage2)
        (unload-zone storage3)
        (unload-zone storage4)
        (unload-zone l7)
        (unload-zone l10)
        

        ;;DELIVERY ZONES
        (delivery-zone delivery1)
        (delivery-zone delivery2)
        (delivery-zone delivery3)
        (delivery-zone delivery4)

        ;;ROBOT1  LOCATION
        (robot-at r1 l3)
        (handempty r1)

        ;;ROBOT2  LOCATION
        (robot-at r2 l11)
        (handempty r2)

        ;;PACKAGE LOCATION
        (package-at pck1 storage1)
        (package-at pck2 storage3)

        (belt-free l4)
        (belt-free l5)
        (belt-free l6)
        (belt-free l10)
        (belt-free l7)
        (belt-free l2)

        (= (total-cost) 0)
    )

    (:goal
        (and
            (package-at pck1 delivery1)
            (package-at pck2 delivery4)
            (< (total-cost) 39)
        )
    )

    (:metric minimize (total-cost))

)