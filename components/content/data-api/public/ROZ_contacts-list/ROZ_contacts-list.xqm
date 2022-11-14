module namespace ROZ_contacts-list = 'content/data-api/public/ROZ_contacts-list';

declare function ROZ_contacts-list:main($params){
  
  let $data :=
    csv:parse(
      fetch:text(
        'https://docs.google.com/spreadsheets/d/e/2PACX-1vSauisyqZbMm9BNiIpfLQ7fkeNuZNg5jlSDGqllUORvgiVXgha6pY_QJgadY2iSks-HlNvnDhGZh8zm/pub?output=csv'
      ),
      map{'header':'yes'}
    )//record
    let $users :=
      for $i in $data[region/text()]
      let $region := $i/region/text()
      order by $region
      group by $region
      let $hasUsername := if($i/telegram_username/text())then('(@)')else()
      return
        $region || $hasUsername
    return
      map{'данные' :
        <result>
          <count_regions>{count(distinct-values($data/region/text()))}</count_regions>
          <count_contacts>{count($data/region/text())}</count_contacts>
          <regions>{
            string-join($users, ';&#10;')
          }</regions>
        </result>
      }
};
