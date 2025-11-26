/**
 *
 * Description :    Alimentation de la table dim_patrimoine_origine
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          patrimoine_origine  
 * Cible :          dim_patrimoine_origine 
 */





    select
        patrimoine_origine_code,
        patrimoine_origine_libelle,
        patrimoine_origine_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_silver"."dbo"."patrimoine_origine"
