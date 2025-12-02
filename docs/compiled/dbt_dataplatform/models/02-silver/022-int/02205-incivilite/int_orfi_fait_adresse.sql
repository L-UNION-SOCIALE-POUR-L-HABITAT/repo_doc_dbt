/**
 *
 * Description :    Alimentation de la table intermediate int_orfi_fait_adresse
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          stg_orfi_fait_adresse
 * Cible :          int_orfi_fait_adresse
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_orfi_fait_adresse as 
(
    select 
        orfi_fait_adresse_id_code,
        orfi_fait_adresse_libelle,
        orfi_fait_adresse_longitude_code,
        orfi_fait_adresse_latitude_code,
        orfi_fait_adresse_commune_libelle,
        orfi_fait_adresse_code_postal
        
    from 
        "wh_dp_silver"."stg"."stg_orfi_fait_adresse"
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
cte_filter_stg_orfi_fait_adresse as 
(
    select 
        *
        
    from 
        cte_stg_orfi_fait_adresse

    Where orfi_fait_adresse_libelle is not null

),



-------------------------------------------------------------------
--************* JOINTURE ET COLONNES CALCULEES ********************
-------------------------------------------------------------------
cte_calc_stg_orfi_fait_adresse  as 
 (
    select
        *
    
    from cte_filter_stg_orfi_fait_adresse
    --left join cte_stg_reference on ....
    --left join cte_stg_orfi_group on ....
 ),


-------------------------------------------------------------------
--********************** CLES TECHNIQUES *************************
-------------------------------------------------------------------
cte_hk_calc_stg_orfi_fait_adresse as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_fait_adresse_id_code as varchar(max))
    
)  
 
         as orfi_fait_adresse_hk
    from 
        cte_calc_stg_orfi_fait_adresse
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
        cte_hk_calc_stg_orfi_fait_adresse
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale