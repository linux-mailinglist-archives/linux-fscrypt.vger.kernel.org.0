Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5231D7859BD
	for <lists+linux-fscrypt@lfdr.de>; Wed, 23 Aug 2023 15:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbjHWNuG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 23 Aug 2023 09:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236298AbjHWNuF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 23 Aug 2023 09:50:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46E0E66;
        Wed, 23 Aug 2023 06:50:00 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37NDiAk4001603;
        Wed, 23 Aug 2023 13:44:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=uaFEgrQr5GSKJQ+2doImaX53YaqjbCwCg842DGcb+0w=;
 b=MYYhy9D0pV+vtW6bcMgSqg4TnYtEolb09pUqbvZBZ1JMgNQIuTvMEPPVMUoy0HeysKoT
 uznVzUJHTvmw4LCJEyfDZmcKjGrolKYnqL1HbiWud8AJfMMteqk1LNnmPmdQbsCzoMZk
 X0PSTVT6lmFKLENohpmsBXUoXmE6IBmbYqKzvjZbTtvfuVhNQvP13gVrUrtU2BsqxZV/
 /t6aT6roxLC+ctwqmn0dRzxYVvBW5mVWjgUPOnOofxaEik/nFJnMoDpaFIR7Jyz8fp1Y
 LBod8jmvRy8sXKVqkR1HRevcns1V4/wyOVkvtbJ8k9P8/LckGzyMqCX1Oj4WsgciSBJg 2g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn1yv1urc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Aug 2023 13:44:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37NCqQvX036051;
        Wed, 23 Aug 2023 13:44:19 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1yuk9qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Aug 2023 13:44:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVYQWncCPJReaxsEWzHlyssB9gVHCjQcaF5fXUDw/uEZy8OXhwzVT7Rj91s1ckN7QvENh8S4KeXQfhR9dMR5GuXGZBWFUalg0CXrbAnrI+MlwFhFz8ALFVJtiv0AsFH9f4+ZoQmJTp1aeVlI/fEcJeWsnlU2xAZYp/2PuyfE0lfUDFhkhrHN7Kx8ljnoQL/8iLctWGhomgWc7CHDOQGtaVR9nLo/YG60T5tV4WfmWqT9DulU5TTw86+rhWbtX5LFr7w43GgeTtB2/wax9r18A/87jhKrOflE0vh3aJ86cvinyDaPX9ldRRT32Ot2m+V/PMDYzMa6nVKxXK/LUpKcHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uaFEgrQr5GSKJQ+2doImaX53YaqjbCwCg842DGcb+0w=;
 b=a531EOKf2sokhmCWA5ITtT4Q9a9VVxT+NDq9fFe2aZmU5V25Z160uFD37Kedw3BUevieFB0kPKlnhcr7t2Hss/dt0jk7Ag89NgTv/ZkqS9RdA49UV7qGquieNkl6WbZ+Xz0+tHPpkS3KyIb3+erCY29eGCiXbTeilPmQfpViAU0Jxm3jwDNnJS5D4EnGcRhBqGEiyLMvjCzWa4n+zbXuvD4NFa3YilpR+EIJr753hUkmzP5XTpJ9Q2yr1DkLFdvSrYWNq0n3DpFneivC4bQxaeEHhtSX7ZQIhp/CEUiyQ4ytufzgjMEdoyjHEKkAtZkAn+Dbn197w0pMuU3aAUwohw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaFEgrQr5GSKJQ+2doImaX53YaqjbCwCg842DGcb+0w=;
 b=OWMNNFVQYeKhzhG6tAawY+ARMENZqIYQ+s5CR7HIeVnKMnQW9wRPXkU3VhQtaTH42p/vGT+fXYAkPyc7aS95jaKjTuiRAxWJMQknJoj8zVz1U03evZcgKeN56IM1azhGMKVp93ieT2+5saBX54ftH/stBaHr+b5ma3HfNGAkHR4=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CO6PR10MB5792.namprd10.prod.outlook.com (2603:10b6:303:14d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.25; Wed, 23 Aug
 2023 13:44:16 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::2990:c166:9436:40e]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::2990:c166:9436:40e%6]) with mapi id 15.20.6699.020; Wed, 23 Aug 2023
 13:44:16 +0000
Date:   Wed, 23 Aug 2023 09:44:11 -0400
From:   Chuck Lever <chuck.lever@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <martineau@kernel.org>,
        Neil Brown <neilb@suse.de>, linux-nfs@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-integrity@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: Re: [PATCH 8/12] SUNRPC: Do not include crypto/algapi.h
Message-ID: <ZOYNK1RflMR9/Akr@tissot.1015granger.net>
References: <ZOXf3JTIqhRLbn5j@gondor.apana.org.au>
 <E1qYlA5-006vH0-3U@formenos.hmeau.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1qYlA5-006vH0-3U@formenos.hmeau.com>
X-ClientProxiedBy: CH2PR12CA0010.namprd12.prod.outlook.com
 (2603:10b6:610:57::20) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|CO6PR10MB5792:EE_
X-MS-Office365-Filtering-Correlation-Id: aa59ebd9-bc5d-48f7-df46-08dba3df0ab7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aAgP7SMs8ZbEU9HjQNPPjJ9XCH0R5OvmUvAaJADW3KE+dLHfgvZCEagGwWGL2OIyHAj8aeowRGJSbvfZG5IZZQ82tOFHSd+BPefgPhfHgo72Co+NcxmyR6akXjaQZAgRju95a+knb1JHqXnF5nbRvHGOQ5FyQRyKCeoXtJoCSd1V2NA6VOKvXeNgn9wTSDrVGF4+Z2O8+c0fReVB7KKH3vzBvOBD5Jw3WIHu55EMABOSTVJJ64ToDdI5GLbRlvqWfQMJvhUHPiuCzg0dSYNRymnKymQVzDt42ARiMjLjxQHGLkfKwOC6Lo0QFjiRpRzXKTWIOfEH9qVn5QcMCntn1xQKI/2t3Tfp4OPDArkj17m909tVm7lLiDwkHIbKQi7+FXQL/BRAnidXSYaHFj0CtElKVtLkATjooWs6nyQj0cVA3Gm+cSBkaiDzq33NI5Ww2QL11OUAuIhAgr46mQ13vIUJ4KBVBBCOZaLr8ovCeQVrTbEPXCO5XOx17MK9ZcwTq3MUZP3MC0NYZSWdV9h3pEu+PdYL9gL60uEpss2ZgdFvM8CN6Zj3TFK28O2JmzWX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(346002)(39860400002)(136003)(396003)(1800799009)(186009)(451199024)(478600001)(6666004)(6486002)(6506007)(9686003)(6512007)(41300700001)(2906002)(26005)(7416002)(8936002)(4326008)(44832011)(316002)(54906003)(6916009)(5660300002)(8676002)(66946007)(86362001)(66556008)(66476007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HjfwHAZjBfKE5YOECk52/L4sF1366/9UTqPiRVFPYra2q/5FTyleBf6dWf2t?=
 =?us-ascii?Q?QsN1p3lkLnRZtDQsdl077kNfKMfbmJtvmrZh3T+3maVoC/Hsl4Vh3ErZHosr?=
 =?us-ascii?Q?4hCX8n9Mbx2gDRCreBUlFjSWuIO4teotUdhgl08I2OS6cKtX5yJ5OnqZiHUy?=
 =?us-ascii?Q?45aIJUTx6wBHz8lUi8n+BcFKsQB1Fm4e6ktjfGjXDU7jzUdwAa4oUMr9T1HU?=
 =?us-ascii?Q?1/KaUrFwmd59fGFw0UtCzhm6CM2N0WaCgegVera6uRiS6PG3QGtNyPOam1in?=
 =?us-ascii?Q?a2cQJKASSyVCUxBAAom4dS1fGVMR4qOT1NfsljBa/MULqXpQAB/fHihRHvTN?=
 =?us-ascii?Q?xTixmxz2iRDxnTo+3bagTY0H6hjd+g9QX+oPYe7HIY44+ZatuRvC25hp8ucl?=
 =?us-ascii?Q?uzqJfydXU6LEzSeNNZpTcb/jK7m7AMwiexhAWZ1+NyaSKdhL2qT/MnUbBQxe?=
 =?us-ascii?Q?kpjT+xh6iLAiWzM2GwoSjTyXYbOQenmb3GOVu246Wddy928inAnjouBdgjsC?=
 =?us-ascii?Q?/pA1gYICuziMM1iZbji+FA7GbUDEPNSwx3/QO+kBADdmBn+7vXlIcWTd9eMT?=
 =?us-ascii?Q?fY2AYxCKma4kEv8rA8T0aAa841ZuEGNxO2lba2qOkjsD2enOe+CHmmcGe43m?=
 =?us-ascii?Q?m6D4kQnFIDPwnTBA824UEGm78q01JHHy6Zr2+leIMi+E726QJ3VJw8u1JA9z?=
 =?us-ascii?Q?ybsQOi3oQjIbM/lzAHKNjlOEIy71KSKRgWrSgebPewT7QtLQ2Hv16iMVY99C?=
 =?us-ascii?Q?0yLh0DIFoRBq8xpvI+VZfUDZinsaQdKjxTUlWLsKkDUTQwYNlxPDH5ayzP0a?=
 =?us-ascii?Q?VavhA3HerqH0ZIyGir30jCKI9ficnBkrGR0xQcUksPX+KWxAocfncjEUIFoM?=
 =?us-ascii?Q?94/8Z4VVmFb5sBdoPzeLnadZlRKzBjNl53NOrw1HBSUEJHOFV0PnN8e2JKQq?=
 =?us-ascii?Q?tvJimAk2sRlTCJDu9saPunbEWdc0C9oPFNDo5sR4kZ57ktiEP4W6tRzkx+QP?=
 =?us-ascii?Q?SMW5Cmhkl8I13j+MJYfCHds0b21oNAjX9jUUO3zDq6jUutBoDsFsXdlJaV5Z?=
 =?us-ascii?Q?J3qBjAlGBdw2AFU09vID06T2Ol48XfqQD4dlL8CqeSAZ9wnkD93VaklIGPP5?=
 =?us-ascii?Q?HAJxr05BOrQ+sUMJbR2z/e7Vy7khG1hYRi680YexnTUG/FZgV2t/y9xPgxdv?=
 =?us-ascii?Q?z9inua1NTg88e4FWiKd+u8kQLAIM32NDUmb+Dop86rp4boi1Vp7EEfw6qCmo?=
 =?us-ascii?Q?CRdvvoI7WKGmIr+35/DewRaZu3B3eMtgo6nu5GdP8Yo0oZZfPiX4ssIi/kA1?=
 =?us-ascii?Q?dq08FVQi16knBK2LP2pibgGteAB8IEwhq/I3usS9q2OB4X4vsjKamLgFCwpf?=
 =?us-ascii?Q?PLz7Udr+3Uc1/WPsaOjjSP/ZTacBue0docamFfwklCNlD4FR2uYF8Qq3wIGv?=
 =?us-ascii?Q?pZoZfiKePY+f34oWqIqS5x13OxlQzdJn9agYyjynzYegKMFCDzRxa2FqTVBL?=
 =?us-ascii?Q?VGT7osqP/KX5AkrKfqgxCS0P7mR/T+SzuEkRgCM8/R3D4vlFhW5uA+ZtKxMM?=
 =?us-ascii?Q?8cHE/rT9qFxwlp2CNqlARqOPYL926omv/ex8iZlDzPx5C5cRh785HVhXmNlG?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?ROEggKKm8GicLh7rc6rtMuV3/eWz4WI3BKHhjDf5X4IvSo9eNFWnu4W3+2zu?=
 =?us-ascii?Q?Zwjt0xpCq/Ihu5xkxruJLQNPKaSUedM5I9McrKU3K48QJ0/7FB748i9J6aH1?=
 =?us-ascii?Q?zSIVMNVXweyPs1DACwDNddtQAkZXlrWbj4GfMovCxd1ZG7FqqnRGsrhkV0ty?=
 =?us-ascii?Q?eQ0H/I+AyLXSzFUi5FgflrxnQ8YqcPpAT4TSa4429yyjgZy296wN1XZe6ILi?=
 =?us-ascii?Q?ptcEVryL5XwXVtn6G5I0SMx50a0Mb49HcIUnjn/wnTeGf10t7kkXP+Upc701?=
 =?us-ascii?Q?NR3+ciIsZC3yv2B7guVuGIIbT/bJpF/5H9UwIxaMqRCVDgvAt0uJ0rQ+Zud1?=
 =?us-ascii?Q?8fJ18EO8PYoPShh9MDQctWW+1rVdehcHQH0CAGQY2ONC9cuHeFRrfPOSabyH?=
 =?us-ascii?Q?Od9ZfxfFENiEVCEO5VAAzjT6PzH+yrUdUFHWw0uwBYsfBlXGsdiRB4osDlyw?=
 =?us-ascii?Q?iPcdPuMeuM86rXnXRMfCNBovjRTzef/sO74Psf/PYmyGnn/MYH/4kU6DUJB1?=
 =?us-ascii?Q?V/LIZNW2S78EKJ1HlXKaldjtY4/+HiFTowSSQ10y6uDgrPFEAZM9swvzZfn6?=
 =?us-ascii?Q?Jpo0N1UGFgCUxi6nZg5yfwaFauyRhamlpXbfqQ6OLr/idFZ1IMkTtcA6Yv0v?=
 =?us-ascii?Q?3cnz/SudPMvbJ15Ue8E1LmY1nN9T8S9J/dMQvQp1vshkFlXdfRpDrwyRco6h?=
 =?us-ascii?Q?nN4wYJ9mZrXOcJxR7xoZTcLAfihWpLkbnRwZtJnNj+uS9YFh4l4d4N4oaxky?=
 =?us-ascii?Q?aaUGGVuyqW4lLqn0rmgj6guyZ1CXgFagOM2Xf8x9OWqf8h2s4QdzttbDoDyo?=
 =?us-ascii?Q?CPJ2fVCJDGVL6v/RdMGyZiSIM3bTaxakrMJ+VrFqnawQbmkZhLJuvIsG1BSA?=
 =?us-ascii?Q?rQLHtMzNTj0Dxtln4zWDXsF+9QrZWKB3CKCd67WWV7XHHXtGH1+bxw2NcozW?=
 =?us-ascii?Q?YN/j+zr78bPZ3WYWrVfB8tceGgZFabCuZHOd8QjNpArmtZkGFLz/ChCLrrPv?=
 =?us-ascii?Q?U3KOuGVdXzzzvWMMUChsh0kw+uQ7KZziMPIXd3rdyIEqFh+hJxLvwRWXrGoR?=
 =?us-ascii?Q?zsSXGHZmMJ3RhXLYcSyzkMCWYdI37W4cdnCGxUGtwGLeOGpxnIVEe9Q/Z73r?=
 =?us-ascii?Q?sKFIkBQsaIv2kmh2tuohZIe/QWSaDNb5H5+8ydhkvS5qyEFDPTatefzL3aKF?=
 =?us-ascii?Q?AfQDK2sqlwP8lzdYoZaSiKxgbjGbgET3PXU5SuyEp5Qq5Jk/fkraS22yV20V?=
 =?us-ascii?Q?MpJKro+0oyFVlqSRgU+iT/3+yrrOCNiebMVlwEfBOTAcTORTpwmOokp8a085?=
 =?us-ascii?Q?FrU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa59ebd9-bc5d-48f7-df46-08dba3df0ab7
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2023 13:44:15.9759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9kW/P/8YTDMg/0LKtoV1eaGbYBN8jfX6kHA6TP3xOnB6jqX2x/fn6tH7VChCxTQenVu3rzGavQicD0AVRkBFEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5792
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-23_08,2023-08-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308230125
X-Proofpoint-GUID: m009a8EOqSuInTzjm_GTn6ReEqgBFcOe
X-Proofpoint-ORIG-GUID: m009a8EOqSuInTzjm_GTn6ReEqgBFcOe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 23, 2023 at 06:32:30PM +0800, Herbert Xu wrote:
> The header file crypto/algapi.h is for internal use only.  Use the
> header file crypto/utils.h instead.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Chuck Lever <chuck.lever@oracle.com>


> ---
> 
>  net/sunrpc/auth_gss/gss_krb5_crypto.c |    2 +-
>  net/sunrpc/auth_gss/gss_krb5_unseal.c |    2 --
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/net/sunrpc/auth_gss/gss_krb5_crypto.c b/net/sunrpc/auth_gss/gss_krb5_crypto.c
> index 9734e1d9f991..d2b02710ab07 100644
> --- a/net/sunrpc/auth_gss/gss_krb5_crypto.c
> +++ b/net/sunrpc/auth_gss/gss_krb5_crypto.c
> @@ -34,9 +34,9 @@
>   * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
>   */
>  
> -#include <crypto/algapi.h>
>  #include <crypto/hash.h>
>  #include <crypto/skcipher.h>
> +#include <crypto/utils.h>
>  #include <linux/err.h>
>  #include <linux/types.h>
>  #include <linux/mm.h>
> diff --git a/net/sunrpc/auth_gss/gss_krb5_unseal.c b/net/sunrpc/auth_gss/gss_krb5_unseal.c
> index 7d6d4ae4a3c9..b3ca30544e70 100644
> --- a/net/sunrpc/auth_gss/gss_krb5_unseal.c
> +++ b/net/sunrpc/auth_gss/gss_krb5_unseal.c
> @@ -57,11 +57,9 @@
>   * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
>   */
>  
> -#include <crypto/algapi.h>
>  #include <linux/types.h>
>  #include <linux/jiffies.h>
>  #include <linux/sunrpc/gss_krb5.h>
> -#include <linux/crypto.h>
>  
>  #include "gss_krb5_internal.h"
>  

-- 
Chuck Lever
