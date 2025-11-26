/**
 *
 * Description :    Alimentation de la table dim_dpe_ges
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          dpe_ges
 * Cible :          dim_dpe_ges 
 */





    select
        dpe_ges_code,
        dpe_ges_libelle,
        dpe_ges_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_silver"."dbo"."dpe_ges"
