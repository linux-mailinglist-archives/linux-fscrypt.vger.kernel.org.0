Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CDF787C4A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Aug 2023 01:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbjHXX6s (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 24 Aug 2023 19:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244093AbjHXX6h (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 24 Aug 2023 19:58:37 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F74212D;
        Thu, 24 Aug 2023 16:58:05 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37ONtR7Y010594;
        Thu, 24 Aug 2023 23:57:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : date : in-reply-to : references : content-type : mime-version
 : content-transfer-encoding; s=pp1;
 bh=YnlPHR/hwH5qnykFXHXCdGujskzarfLxFMtXePb+Bp8=;
 b=Mgy77CoYgffelRskx96UqY+AI6UBmjwiA1BtrxmJvh8wJZbL3IqEybxEtmIWU4FLt6vG
 29u+vjpCF/xP6MeW1/0w7+ZmwV0ws858zh2Z+7k+HgTNOlqSgWy0Q59+iUDExZ4VdqqU
 MV8yDb9G8aM5mCr/RuiOi/O0qDRQzd5mjWz1e2yTzUP+wdkbgIqvR5uKT12c3DpXT7Hr
 ATuOC1qDCzH64PeKnBW0gpsPVwXNY4+pmPEXhY/eXeQfIOwWZ+/3ANTTqolfC37ZqJ87
 UaCvctpDmajTUi0ePgWWeRX9FM8pya8YFuLkNZyebl7tyLjkk4iS1WgKXRdaMU7JD3PR RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sph6r0516-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 23:57:33 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37ONpHmf029212;
        Thu, 24 Aug 2023 23:57:32 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sph6r050w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 23:57:32 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OLMvBU018270;
        Thu, 24 Aug 2023 23:57:32 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sn21sub5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 23:57:32 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37ONvVTt7602738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 23:57:31 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88D935805A;
        Thu, 24 Aug 2023 23:57:31 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28F3158051;
        Thu, 24 Aug 2023 23:57:30 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.61.163.153])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 23:57:30 +0000 (GMT)
Message-ID: <1905e842f2f74705aa2f7d407c58171c72686cdf.camel@linux.ibm.com>
Subject: Re: [PATCH 10/12] KEYS: encrypted: Do not include crypto/algapi.h
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
Date:   Thu, 24 Aug 2023 19:57:29 -0400
In-Reply-To: <E1qYlA9-006vIz-Am@formenos.hmeau.com>
References: <ZOXf3JTIqhRLbn5j@gondor.apana.org.au>
         <E1qYlA9-006vIz-Am@formenos.hmeau.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-22.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fAHUKh1opEl8_Dv_I_X3dM8kVdC0roQH
X-Proofpoint-GUID: Pbj_ah2ai_Uy70mnZVchutrhpFA2Kgd9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_18,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 clxscore=1015 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308240205
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
>  security/keys/encrypted-keys/encrypted.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
> index 1e313982af02..8af2136069d2 100644
> --- a/security/keys/encrypted-keys/encrypted.c
> +++ b/security/keys/encrypted-keys/encrypted.c
> @@ -27,10 +27,10 @@
>  #include <linux/scatterlist.h>
>  #include <linux/ctype.h>
>  #include <crypto/aes.h>
> -#include <crypto/algapi.h>
>  #include <crypto/hash.h>
>  #include <crypto/sha2.h>
>  #include <crypto/skcipher.h>
> +#include <crypto/utils.h>
>  
>  #include "encrypted.h"
>  #include "ecryptfs_format.h"


