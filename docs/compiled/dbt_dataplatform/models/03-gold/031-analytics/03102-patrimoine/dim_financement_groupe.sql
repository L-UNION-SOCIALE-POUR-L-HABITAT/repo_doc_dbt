/**
 *
 * Description :    Alimentation de la table dim_financement_groupe
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          financement_groupe 
 * Cible :          dim_financement_groupe 
 */





    select
        financement_groupe_code,
        financement_groupe_libelle,
        financement_groupe_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_silver"."dbo"."financement_groupe"
