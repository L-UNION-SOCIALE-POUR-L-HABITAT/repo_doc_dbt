/**
 *
 * Description :    Alimentation de la table intermediate int_organisme
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          stg_crm_entreprise
 * Cible :          int_organisme
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_entreprise as 
(
    select 
        organisme_raison_sociale_libelle,
        organisme_statut_code,
        organisme_type_code,
        organisme_siren_code,
        organisme_sous_famille_code,
        organisme_code_union,
        organisme_id_code
        
    from 
        "wh_dp_silver"."stg"."stg_crm_entreprise"
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
cte_filter_stg_entreprise as 
(
    select 
        *
        
    from 
        cte_stg_entreprise

    where organisme_statut_code = 'ACT'
),

-------------------------------------------------------------------
--************* JOINTURE ET COLONNES CALCULEES ********************
-------------------------------------------------------------------
cte_calc_stg_entreprise  as 
 (
    select
        organisme_raison_sociale_libelle,
        organisme_statut_code,
        organisme_type_code,
        organisme_siren_code,
        organisme_sous_famille_code,
        organisme_code_union,
        organisme_id_code
    
    from cte_filter_stg_entreprise
    --left join cte_stg_reference on ....
    --left join cte_stg_orfi_group on ....
 ),


-------------------------------------------------------------------
--********************** CLES TECHNIQUES *************************
-------------------------------------------------------------------
cte_hk_calc_stg_entreprise as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(organisme_id_code as varchar(max))
    
)  
 
           as organisme_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(organisme_statut_code as varchar(max))
    
)  
 
       as organisme_statut_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(organisme_type_code as varchar(max))
    
)  
 
         as organisme_type_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(organisme_sous_famille_code as varchar(max))
    
)  
 
  as organisme_sous_famille_hk
         
    from 
        cte_calc_stg_entreprise
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
        cte_hk_calc_stg_entreprise
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale