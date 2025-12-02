
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "int"."int_orfi_agence__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table intermediate int_orfi_agence
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          stg_orfi_agence
 * Cible :          int_orfi_agence
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_orfi_agence as 
(
    select 
        orfi_agence_id_code,
        orfi_agence_libelle,
        orfi_secteur_id_code,
        orfi_agence_code,
        orfi_agence_active_flag

        
    from 
        "wh_dp_silver"."stg"."stg_orfi_agence"
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
cte_filter_stg_orfi_agence as 
(
    select 
        *
        
    from 
        cte_stg_orfi_agence

),



-------------------------------------------------------------------
--************* JOINTURE ET COLONNES CALCULEES ********************
-------------------------------------------------------------------
cte_calc_stg_orfi_agence  as 
 (
    select
        *
    
    from cte_filter_stg_orfi_agence
    --left join cte_stg_reference on ....
    --left join cte_stg_orfi_group on ....
 ),


-------------------------------------------------------------------
--********************** CLES TECHNIQUES *************************
-------------------------------------------------------------------
cte_hk_calc_stg_orfi_agence as
(
    select 
        *
        , 
     
        HASHBYTES(''SHA2_256'', 
    
        cast(orfi_agence_id_code as varchar(max))
    
)  
 
         as orfi_agence_hk
        , 
     
        HASHBYTES(''SHA2_256'', 
    
        cast(orfi_secteur_id_code as varchar(max))
    
)  
 
        as orfi_secteur_hk
    from 
        cte_calc_stg_orfi_agence
),
 
-------------------------------------------------------------------
--********************** ETAPE FINALE *************************
-------------------------------------------------------------------
 
 cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_stg_orfi_agence
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."int"."int_orfi_agence__dbt_temp" AS SELECT * FROM "wh_dp_silver"."int"."int_orfi_agence__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  