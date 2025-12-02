/**
 *
 * Description :    Alimentation de la table intermediate int_orfi_asso_plainte_statut
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          stg_orfi_asso_plainte_statut
 * Cible :          int_orfi_asso_plainte_statut
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_orfi_asso_plainte_statut as 
(
    select 
        orfi_asso_plainte_statut_id_code,
        orfi_statut_id_code,
        orfi_plainte_id_code
      
    from 
        "wh_dp_silver"."stg"."stg_orfi_asso_plainte_statut"
),


/*
cte_stg_reference as
(

),

cte_stg_orfi_group as 
(

)
*/

 
-------------------------------------------------------------------
--************************** FILTRAGE ****************************
-------------------------------------------------------------------

-- on souhaite recueperer que les organismes actifs
cte_filter_stg_orfi_asso_plainte_statut as 
(
    select 
        *
        
    from 
        cte_stg_orfi_asso_plainte_statut

),



-------------------------------------------------------------------
--************* JOINTURE ET COLONNES CALCULEES ********************
-------------------------------------------------------------------
cte_calc_stg_orfi_asso_plainte_statut  as 
 (
    select
        *
    
    from cte_filter_stg_orfi_asso_plainte_statut
    --left join cte_stg_reference on ....
    --left join cte_stg_orfi_group on ....
 ),


-------------------------------------------------------------------
--********************** CLES TECHNIQUES *************************
-------------------------------------------------------------------
cte_hk_calc_stg_orfi_asso_plainte_statut as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_asso_plainte_statut_id_code as varchar(max))
    
)  
 
         as orfi_asso_plainte_statut_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_statut_id_code as varchar(max))
    
)  
 
                       as orfi_statut_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_plainte_id_code as varchar(max))
    
)  
 
                      as orfi_plainte_hk

        
    from 
        cte_calc_stg_orfi_asso_plainte_statut
),
 
-------------------------------------------------------------------
--********************** ETAPE FINALE *************************
-------------------------------------------------------------------
 
 cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_stg_orfi_asso_plainte_statut
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale