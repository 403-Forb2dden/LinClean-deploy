resource "aws_route53_record" "tfer--Z04489651RTX4SKR88HB1_accounts-002E-linclean-002E-kr-002E-_CNAME_" {
  multivalue_answer_routing_policy = "false"
  name                             = "accounts.linclean.kr"
  records                          = ["accounts.clerk.services"]
  ttl                              = "300"
  type                             = "CNAME"
  zone_id                          = "${aws_route53_zone.tfer--Z04489651RTX4SKR88HB1_linclean-002E-kr.zone_id}"
}

resource "aws_route53_record" "tfer--Z04489651RTX4SKR88HB1_api-002E-linclean-002E-kr-002E-_A_" {
  multivalue_answer_routing_policy = "false"
  name                             = "api.linclean.kr"
  records                          = ["3.35.92.248"]
  ttl                              = "300"
  type                             = "A"
  zone_id                          = "${aws_route53_zone.tfer--Z04489651RTX4SKR88HB1_linclean-002E-kr.zone_id}"
}

resource "aws_route53_record" "tfer--Z04489651RTX4SKR88HB1_clerk-002E-linclean-002E-kr-002E-_CNAME_" {
  multivalue_answer_routing_policy = "false"
  name                             = "clerk.linclean.kr"
  records                          = ["frontend-api.clerk.services"]
  ttl                              = "300"
  type                             = "CNAME"
  zone_id                          = "${aws_route53_zone.tfer--Z04489651RTX4SKR88HB1_linclean-002E-kr.zone_id}"
}

resource "aws_route53_record" "tfer--Z04489651RTX4SKR88HB1_clk-002E-_domainkey-002E-linclean-002E-kr-002E-_CNAME_" {
  multivalue_answer_routing_policy = "false"
  name                             = "clk._domainkey.linclean.kr"
  records                          = ["dkim1.jv1fv7xo5kut.clerk.services"]
  ttl                              = "300"
  type                             = "CNAME"
  zone_id                          = "${aws_route53_zone.tfer--Z04489651RTX4SKR88HB1_linclean-002E-kr.zone_id}"
}

resource "aws_route53_record" "tfer--Z04489651RTX4SKR88HB1_clk2-002E-_domainkey-002E-linclean-002E-kr-002E-_CNAME_" {
  multivalue_answer_routing_policy = "false"
  name                             = "clk2._domainkey.linclean.kr"
  records                          = ["dkim2.jv1fv7xo5kut.clerk.services"]
  ttl                              = "300"
  type                             = "CNAME"
  zone_id                          = "${aws_route53_zone.tfer--Z04489651RTX4SKR88HB1_linclean-002E-kr.zone_id}"
}

resource "aws_route53_record" "tfer--Z04489651RTX4SKR88HB1_clkmail-002E-linclean-002E-kr-002E-_CNAME_" {
  multivalue_answer_routing_policy = "false"
  name                             = "clkmail.linclean.kr"
  records                          = ["mail.jv1fv7xo5kut.clerk.services"]
  ttl                              = "300"
  type                             = "CNAME"
  zone_id                          = "${aws_route53_zone.tfer--Z04489651RTX4SKR88HB1_linclean-002E-kr.zone_id}"
}

resource "aws_route53_record" "tfer--Z04489651RTX4SKR88HB1_linclean-002E-kr-002E-_NS_" {
  multivalue_answer_routing_policy = "false"
  name                             = "linclean.kr"
  records                          = ["ns-1399.awsdns-46.org.", "ns-1678.awsdns-17.co.uk.", "ns-355.awsdns-44.com.", "ns-987.awsdns-59.net."]
  ttl                              = "172800"
  type                             = "NS"
  zone_id                          = "${aws_route53_zone.tfer--Z04489651RTX4SKR88HB1_linclean-002E-kr.zone_id}"
}

resource "aws_route53_record" "tfer--Z04489651RTX4SKR88HB1_linclean-002E-kr-002E-_SOA_" {
  multivalue_answer_routing_policy = "false"
  name                             = "linclean.kr"
  records                          = ["ns-355.awsdns-44.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
  ttl                              = "900"
  type                             = "SOA"
  zone_id                          = "${aws_route53_zone.tfer--Z04489651RTX4SKR88HB1_linclean-002E-kr.zone_id}"
}
