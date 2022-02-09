getSidoCode(String addr){
  final _splitted = addr.split(' ');
  switch (_splitted[0]) {
    case '서울특별시':
      return '11';
    case '부산광역시':
      return '21';
    case '대구광역시':
      return '22';
    case '인천광역시':
      return '23';
    case '광주광역시':
      return '24';
    case '대전광역시':
      return '25';
    case '울산광역시':
      return '26';
    case '세종특별자치시':
      return '29';
    case '경기도':
      return '31';
    case '강원도':
      return '32';
    case '충청북도':
      return '33';
    case '충청남도':
      return '34';
    case '전라북도':
      return '35';
    case '전라남도':
      return '36';
    case '경상북도':
      return '37';
    case '경상남도':
      return '38';
    case '제주특별자치도':
      return '39';
    default:
      return '99';
  }
}