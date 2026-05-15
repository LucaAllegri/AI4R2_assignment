(define (problem PDDL_PLUS_Q2) 

    (:domain PDDL_plus_Warehouse_Conveyor)
    (:objects 
        r1 r2 r3 r4 r5 r6 r7 - robot

        storage1 l1 l2 l3 storage2
        l5 l6 l7 l8 l9 l10 l11
        l12 l13 l14 l15 l16 l17 l18
        l19 l20 l21 l22 l23 l24 l25
        l26 l27 l28 l29 l30 l31 l32 - location

        delivery1 delivery2 delivery3 delivery4 delivery5 delivery6 - location
        delivery7 delivery8 delivery9 delivery10 delivery11 delivery12 - location

        cMain cRight cLeft cBackR cBackL - conveyor

        p1 p2 p3 p4 p5 - package 
    )

    (:init

        ;; BELT SEGMENTS OF THE CONVEYORS
        (belt-segment cMain storage1 l1)
        (belt-segment cMain l1 l2)
        (belt-segment cMain l2 l3)
        (belt-segment cMain l3 storage2)

        (belt-segment cRight l5 l6)
        (belt-segment cRight l6 l7)
        (belt-segment cRight l7 l8)
        (belt-segment cRight l8 l9)
        (belt-segment cRight l9 l10)
        (belt-segment cRight l10 l11)

        (belt-segment cLeft l19 l20)
        (belt-segment cLeft l20 l21)
        (belt-segment cLeft l21 l22)
        (belt-segment cLeft l22 l23)
        (belt-segment cLeft l23 l24)
        (belt-segment cLeft l24 l25)

        (belt-segment cBackR l12 l13)
        (belt-segment cBackR l13 l14)
        (belt-segment cBackR l14 l15)
        (belt-segment cBackR l15 l16)
        (belt-segment cBackR l16 l17)
        (belt-segment cBackR l17 l18)
        (belt-segment cBackR l18 storage1)

        (belt-segment cBackL l26 l27)
        (belt-segment cBackL l27 l28)
        (belt-segment cBackL l28 l29)
        (belt-segment cBackL l29 l30)
        (belt-segment cBackL l30 l31)
        (belt-segment cBackL l31 l32)
        (belt-segment cBackL l32 storage1)
        ;;---------------------------------

        ;; CONVEYOR ENTRIES
        (conveyor-entry cMain storage1)
        (conveyor-entry cRight l5)
        (conveyor-entry cLeft l19)
        (conveyor-entry cBackR l12)
        (conveyor-entry cBackL l26)
        ;;---------------------------------

        ;; CONVEYOR EXITS
        (conveyor-exit cMain storage2)
        (conveyor-exit cRight l11)
        (conveyor-exit cLeft l25)
        (conveyor-exit cBackR storage1)
        (conveyor-exit cBackL storage1)
        ;;---------------------------------

        ;;CONVEYOR CONNECTED
        (conveyor-connected cRight cBackR l11 l12)
        (conveyor-connected cLeft cBackL l25 l26)
        (conveyor-connected cBackR cMain storage1 storage1)
        (conveyor-connected cBackL cMain storage1 storage1)
        ;;---------------------------------

        ;; UNLOADING ZONES
        (unload-zone storage2)
        (unload-zone l7)
        (unload-zone l9)
        (unload-zone l11)
        (unload-zone l21) 
        (unload-zone l23)
        (unload-zone l25)
        ;;---------------------------------

        ;; PICKING ZONES
        (load-zone l5)
        (load-zone l19)
        ;;---------------------------------

        ;; DELIVERY ZONES
        (delivery-zone delivery1)
        (delivery-zone delivery2)
        (delivery-zone delivery3)
        (delivery-zone delivery4)
        (delivery-zone delivery5)
        (delivery-zone delivery6)
        (delivery-zone delivery7)
        (delivery-zone delivery8)
        (delivery-zone delivery9)
        (delivery-zone delivery10)
        (delivery-zone delivery11)
        (delivery-zone delivery12)
        ;;---------------------------------

        ;; ROBOT ACTION ZONES
        (robot-act-on r1 storage2)
        (robot-act-on r1 l5)
        (robot-act-on r1 l19)
        (robot-act-on r2 l7)
        (robot-act-on r2 delivery1)
        (robot-act-on r2 delivery2)
        (robot-act-on r3 l9)
        (robot-act-on r3 delivery3)
        (robot-act-on r3 delivery4)
        (robot-act-on r4 l11)
        (robot-act-on r4 delivery5)
        (robot-act-on r4 delivery6)
        (robot-act-on r5 l21)
        (robot-act-on r5 delivery7)
        (robot-act-on r5 delivery8)
        (robot-act-on r6 l23)
        (robot-act-on r6 delivery9)
        (robot-act-on r6 delivery10)
        (robot-act-on r7 l25)
        (robot-act-on r7 delivery11)
        (robot-act-on r7 delivery12)
        ;;---------------------------------

        ;; INITIAL ROBOT POSITIONS
        (robot-at r1 storage2)
        (robot-at r2 l7)
        (robot-at r3 l9)
        (robot-at r4 l11)
        (robot-at r5 l21)
        (robot-at r6 l23)
        (robot-at r7 l25)

        (handempty r1)
        (handempty r2)
        (handempty r3)
        (handempty r4)
        (handempty r5)
        (handempty r6)
        (handempty r7)
        ;;---------------------------------

        ;; INITIAL PACKAGE POSITIONS
        (package-at p1 l2)
        (on-belt p1 cMain)

        (package-at p2 l3)
        (on-belt p2 cMain)
        ;;---------------------------------

        ;; BELT FREE
        ;; cMain
        (belt-free l1) (belt-free storage1) (belt-free storage2)

        ;; cRight
        (belt-free l5)  (belt-free l6)  (belt-free l7)  (belt-free l8)
        (belt-free l9)  (belt-free l10) (belt-free l11)

        ;; cLeft
        (belt-free l19) (belt-free l20) (belt-free l21) (belt-free l22)
        (belt-free l23) (belt-free l24) (belt-free l25)

        ;; cBackR
        (belt-free l12) (belt-free l13) (belt-free l14) (belt-free l15)
        (belt-free l16) (belt-free l17) (belt-free l18)

        ;; cBackL
        (belt-free l26) (belt-free l27) (belt-free l28) (belt-free l29)
        (belt-free l30) (belt-free l31) (belt-free l32)

        (belt-running cMain)
        (belt-running cRight)
        (belt-running cLeft)
        (belt-running cBackR)
        (belt-running cBackL)
        ;;---------------------------------

        ;; NUMERIC INITIALIZATION
        (= (belt-progress p1) 0.0)
        (= (belt-progress p2) 0.0)
        (= (belt-progress p3) 0.0)
        (= (belt-progress p4) 0.0)
        (= (belt-progress p5) 0.0)

        (= (conveyor-speed cMain)  1.0)
        (= (conveyor-speed cRight) 1.0)
        (= (conveyor-speed cLeft)  1.0)
        (= (conveyor-speed cBackR) 1.0)
        (= (conveyor-speed cBackL) 1.0)

        (= (total-cost) 0)
        ;;---------------------------------

    )


    (:goal (and
        (package-at p1 delivery2)
        (package-at p2 delivery2)
        
    ))

    (:metric minimize (total-cost))

)
