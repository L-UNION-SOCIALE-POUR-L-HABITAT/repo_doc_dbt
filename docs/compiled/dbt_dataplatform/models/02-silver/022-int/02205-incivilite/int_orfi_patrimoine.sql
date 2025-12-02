/**
 *
 * Description :    Alimentation de la table intermediate int_orfi_patrimoine
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          stg_orfi_patrimoine
 * Cible :          int_orfi_patrimoine
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_orfi_patrimoine as 
(
    select 
        orfi_patrimoine_id_code,
        orfi_patrimoine_libelle,
        organisme_code_union,
        orfi_patrimoine_code
      
    from 
        "wh_dp_silver"."stg"."stg_orfi_patrimoine"
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
cte_filter_stg_orfi_patrimoine as 
(
    select 
        *
        
    from 
        cte_stg_orfi_patrimoine

),



-------------------------------------------------------------------
--************* JOINTURE ET COLONNES CALCULEES ********************
-------------------------------------------------------------------
cte_calc_stg_orfi_patrimoine  as 
 (
    select
        *
    
    from cte_filter_stg_orfi_patrimoine
    --left join cte_stg_reference on ....
    --left join cte_stg_orfi_group on ....
 ),


-------------------------------------------------------------------
--********************** CLES TECHNIQUES *************************
-------------------------------------------------------------------
cte_hk_calc_stg_orfi_patrimoine as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_patrimoine_id_code as varchar(max))
    
)  
 
         as orfi_patrimoine_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(organisme_code_union as varchar(max))
    
)  
 
            as organisme_code_union_hk
    from 
        cte_calc_stg_orfi_patrimoine
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
        cte_hk_calc_stg_orfi_patrimoine
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale