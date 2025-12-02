
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "int"."int_orfi_secteur__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table intermediate int_orfi_secteur
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          stg_orfi_secteur
 * Cible :          int_orfi_secteur
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_orfi_secteur as 
(
    select 
        orfi_secteur_id_code,
        orfi_secteur_libelle,
        orfi_patrimoine_id_code,
        orfi_secteur_code
      
    from 
        "wh_dp_silver"."stg"."stg_orfi_secteur"
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
cte_filter_stg_orfi_secteur as 
(
    select 
        *
        
    from 
        cte_stg_orfi_secteur

),



-------------------------------------------------------------------
--************* JOINTURE ET COLONNES CALCULEES ********************
-------------------------------------------------------------------
cte_calc_stg_orfi_secteur  as 
 (
    select
        *
    
    from cte_filter_stg_orfi_secteur
    --left join cte_stg_reference on ....
    --left join cte_stg_orfi_group on ....
 ),


-------------------------------------------------------------------
--********************** CLES TECHNIQUES *************************
-------------------------------------------------------------------
cte_hk_calc_stg_orfi_secteur as
(
    select 
        *
        , 
     
        HASHBYTES(''SHA2_256'', 
    
        cast(orfi_secteur_id_code as varchar(max))
    
)  
 
         as orfi_secteur_hk
        , 
     
        HASHBYTES(''SHA2_256'', 
    
        cast(orfi_patrimoine_id_code as varchar(max))
    
)  
 
      as orfi_patrimoine_hk
    from 
        cte_calc_stg_orfi_secteur
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
        cte_hk_calc_stg_orfi_secteur
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."int"."int_orfi_secteur__dbt_temp" AS SELECT * FROM "wh_dp_silver"."int"."int_orfi_secteur__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  