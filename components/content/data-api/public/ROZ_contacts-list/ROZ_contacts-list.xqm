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
      order by $i/region/text()
      let $hasUsername := if($i/telegram_username/text())then('(@)')else()
      return
        $i/region/text() || $hasUsername
    return
      map{'данные' :
        <result>
          <count>{count($users)}</count>
          <regions>{
            string-join($users, ';&#10;') || ';&#10;' || 
            '<a href="tg://user?id=426274250">inline mention of a user</a>'
          }</regions>
        </result>
      }
};
