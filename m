Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE30787C54
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Aug 2023 01:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240381AbjHXX6t (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 24 Aug 2023 19:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244099AbjHXX6h (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 24 Aug 2023 19:58:37 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA1C1FD3;
        Thu, 24 Aug 2023 16:58:06 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37ONvGwO007768;
        Thu, 24 Aug 2023 23:57:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : date : in-reply-to : references : content-type : mime-version
 : content-transfer-encoding; s=pp1;
 bh=oDLt9MGmCExq5NUMRyFjvZAr8DfskIv92nbC1tyNUVE=;
 b=DnLnCzxivBeoZ8KXN2bBCDB/hHKf66oFtodTwucXnODDJwMQmU0nqQ4PfO2bdsvegT6a
 Zd0JI8a8c2ioPHa8vjm2X1t6sB1Esix7BPUqYrpHZQb/MSsY5O+KT76WhhAsCCYZoSf6
 smN4S11DPM0Fx2Q5LRQIr69CYH++vUL+gdtEp8UR3+hGTi4PHz846QD0TZaiQkvmAtUO
 TU6w/6pwQVCETvlWeZDt2DOvYCCpRYptAnJUJQWbUckY/XhqernTFBNUgnn0mSSmnAZA
 H5myYx8rPJrKRUL1+vvKIaPb6VT02GXsY+uG6uDZ2nv2T+9xnYAPDCjXLr6F7hpzwka5 gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3spgad9eey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 23:57:22 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37ONa97Y006045;
        Thu, 24 Aug 2023 23:57:21 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3spgad9eep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 23:57:21 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OLOkcn016727;
        Thu, 24 Aug 2023 23:57:20 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn2283anj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 23:57:20 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37ONvJV1393924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 23:57:20 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDD9458054;
        Thu, 24 Aug 2023 23:57:19 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44BC95804E;
        Thu, 24 Aug 2023 23:57:17 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.61.163.153])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 23:57:17 +0000 (GMT)
Message-ID: <fd2c26dd2c1e0ef5f4640d36e680f94ca064280e.camel@linux.ibm.com>
Subject: Re: [PATCH 9/12] evm: Do not include crypto/algapi.h
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
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
        Chuck Lever <chuck.lever@oracle.com>,
        Neil Brown <neilb@suse.de>, linux-nfs@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Date:   Thu, 24 Aug 2023 19:57:16 -0400
In-Reply-To: <E1qYlA7-006vHq-8B@formenos.hmeau.com>
References: <ZOXf3JTIqhRLbn5j@gondor.apana.org.au>
         <E1qYlA7-006vHq-8B@formenos.hmeau.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-22.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fk1My-hZ_koWxDC0qnmYPIGtla-o51va
X-Proofpoint-ORIG-GUID: H-MHHBlfn9DDClGPap9dlVrVP8XP4Ko1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_18,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1011 suspectscore=0 malwarescore=0 phishscore=0 impostorscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2308100000 definitions=main-2308240205
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2023-08-23 at 18:32 +0800, Herbert Xu wrote:
> The header file crypto/algapi.h is for internal use only.  Use the
> header file crypto/utils.h instead.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Mimi Zohar <zohar@linux.ibm.com>

> ---
> 
>  security/integrity/evm/evm_main.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index c9b6e2a43478..e635a8d18dae 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -14,7 +14,6 @@
>  #define pr_fmt(fmt) "EVM: "fmt
>  
>  #include <linux/init.h>
> -#include <linux/crypto.h>
>  #include <linux/audit.h>
>  #include <linux/xattr.h>
>  #include <linux/integrity.h>
> @@ -24,7 +23,7 @@
>  
>  #include <crypto/hash.h>
>  #include <crypto/hash_info.h>
> -#include <crypto/algapi.h>
> +#include <crypto/utils.h>
>  #include "evm.h"
>  
>  int evm_initialized;


