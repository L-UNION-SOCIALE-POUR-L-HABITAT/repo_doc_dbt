/**
 *
 * Description :    Alimentation de la table dim_pmr
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          pmr
 * Cible :          dim_pmr
 */





    select
        pmr_code,
        pmr_libelle,
        pmr_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_silver"."dbo"."pmr"
