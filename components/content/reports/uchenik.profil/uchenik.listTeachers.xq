declare variable $params external;
declare variable $номерЛичногоДела external;
declare variable $ID external;


let $data := .//table[1]/row
  
return
  <table>
    {
      $data
    }
  </table>