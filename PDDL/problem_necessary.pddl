(define (problem PDDL_Q1_NECESSARY)

    (:domain PDDL_Warehouse_Conveyor)

    (:objects
        storage1 storage2 storage3 storage4 - location
        
        l1 l2 l3 l4 l5
        l6 l7 l8 l9
        l10 l11 l12 l13 l14
        l15 l16 l17 l18 - location

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
        (connected l4 l5)
        (connected l5 l4)
        (connected l5 delivery1)
        (connected delivery1 l5)

        ;; second row of the grid
        (connected storage2 l6)
        (connected l6 storage2)
        (connected l6 l7)
        (connected l7 l6)
        (connected l8 l9)
        (connected l9 l8)
        (connected l9 delivery2)
        (connected delivery2 l9)

        ;; third row of the grid
        (connected storage3 l10)
        (connected l10 storage3)
        (connected l13 l14)
        (connected l14 l13)
        (connected l14 delivery3)
        (connected delivery3 l14)

        ;; fourth row of the grid
        (connected storage4 l15)
        (connected l15 storage4)
        (connected l15 l16)
        (connected l16 l15)
        (connected l17 l18)
        (connected l18 l17)
        (connected l18 delivery4)
        (connected delivery4 l18)

        ;;first column of the grid
        (connected storage1 storage2)
        (connected storage2 storage1)
        (connected storage2 storage3)
        (connected storage3 storage2)
        (connected storage3 storage4)
        (connected storage4 storage3)

        ;;second column of the grid
        (connected l1 l6)
        (connected l6 l1)
        (connected l6 l10)
        (connected l10 l6)
        (connected l10 l15)
        (connected l15 l10)

        ;;third column of the grid
        (connected l2 l7)
        (connected l7 l2)

        ;;fourth column of the grid
        (connected l4 l8)
        (connected l8 l4)
        (connected l8 l13)
        (connected l13 l8)
        (connected l13 l17)
        (connected l17 l13)

        ;;fifth column of the grid
        (connected l5 l9)
        (connected l9 l5)
        (connected l9 l14)
        (connected l14 l9)
        (connected l14 l18)
        (connected l18 l14)

        ;;sixth column of the grid
        (connected delivery1 delivery2)
        (connected delivery2 delivery1)
        (connected delivery2 delivery3)
        (connected delivery3 delivery2)
        (connected delivery3 delivery4)
        (connected delivery4 delivery3)

        ;; TOP CONVEYOR BELT
        (belt-connected l2 l3)
        (belt-connected l3 l4)

        ;; BOTTOM CONVEYOR BELT
        (belt-connected l10 l11)
        (belt-connected l11 l12)
        (belt-connected l12 l13)

        ;;LOAD ZONES
        (load-zone l2)
        (load-zone l10)
        
        ;;UNLOAD ZONES
        (unload-zone storage1)
        (unload-zone storage2)
        (unload-zone storage3)
        (unload-zone storage4)
        (unload-zone l4)
        (unload-zone l13)
        

        ;;DELIVERY ZONES
        (delivery-zone delivery1)
        (delivery-zone delivery2)
        (delivery-zone delivery3)
        (delivery-zone delivery4)

        ;;ROBOT1  LOCATION
        (robot-at r1 l6)
        (handempty r1)

        ;;ROBOT2  LOCATION
        (robot-at r2 l14)
        (handempty r2)

        ;;PACKAGE LOCATION
        (package-at pck1 storage1)
        (package-at pck2 storage3)

        (belt-free l2)
        (belt-free l3)
        (belt-free l4)
        (belt-free l10)
        (belt-free l11)
        (belt-free l12)
        (belt-free l13)

        (= (total-cost) 0)
    )

    (:goal
        (and
            (package-at pck1 delivery1)
            (package-at pck2 delivery4)
            (< (total-cost) 49)
        )
    )

    (:metric minimize (total-cost))

)