module namespace ROZ_contacts = 'content/data-api/public/ROZ_contacts';

declare function ROZ_contacts:main($params){
  
  let $data :=
    csv:parse(
      fetch:text(
        'https://docs.google.com/spreadsheets/d/e/2PACX-1vSauisyqZbMm9BNiIpfLQ7fkeNuZNg5jlSDGqllUORvgiVXgha6pY_QJgadY2iSks-HlNvnDhGZh8zm/pub?output=csv'
      ),
      map{'header':'yes'}
    )//record
    let $user := $data[region/text()=request:parameter('region')]
      
    return
      map{'данные' :
        <result>
          <lastname>{$user/lastname/text()??$user/lastname/text()!!'нет'}</lastname>
          <firstname>{$user/firstname/text()??$user/firstname/text()!!'нет'}</firstname>
          <telegram_username>{$user/telegram_username/text()??$user/telegram_username/text()!!'нет'}</telegram_username>
          <telegram_id>{$user/telegram_id/text()??$user/telegram_id/text()!!'контакт скрыт'}</telegram_id>
        </result>
      }
};
