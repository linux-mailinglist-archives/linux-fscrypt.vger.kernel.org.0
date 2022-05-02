Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D8C516F5B
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 May 2022 14:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353182AbiEBMRv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 May 2022 08:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbiEBMRu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 May 2022 08:17:50 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A46B84B;
        Mon,  2 May 2022 05:14:21 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242B0Yn9029696;
        Mon, 2 May 2022 12:14:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=k2a1Q3umUpC7cls2Dd99KLebyMdsYQy5SRj4onVwGTQ=;
 b=AiETKYkU5ElG1AMFUTlk+1kOaLPYAJqar+nsXEBsLdTirRHJ+l/H0rVhSpKkeWHHvQLy
 UNw5xvJpxR8ny3XEcBBm/GyIAEt75EqRPp58sxJeUGu4cAZsfBcOHzpSR0pIIaBmL4AX
 KsIXN8mT/jIATogUXBpVs28n/oPr16YwgbpqKbPvaE3Cu/RYkqnSirDKODE0XD6Ozb1f
 r44gpmLa5dkkmSr5Hm1eK4jEW+6EQ7uQIeVr2xLB0+Ww4vQLGKgHaehB+NWDAgPMJb7a
 JADWsgo/26xKfeG5MSGuYgDII3vanj0zo61xwmmte/NLmNQX5eMGa1vel0exM8VFKvGz ig== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fte23se8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 12:14:18 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 242CBQTT016878;
        Mon, 2 May 2022 12:14:16 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3frvr8tnd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 12:14:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 242CEEph49021202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 May 2022 12:14:14 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA3544C044;
        Mon,  2 May 2022 12:14:13 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36CC14C040;
        Mon,  2 May 2022 12:14:13 +0000 (GMT)
Received: from sig-9-65-70-224.ibm.com (unknown [9.65.70.224])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 May 2022 12:14:13 +0000 (GMT)
Message-ID: <214f4633d397905edc5fac91d779a6991c753c0c.camel@linux.ibm.com>
Subject: Re: [PATCH v8 1/7] ima: fix 'd-ng' comments and documentation
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Stefan Berger <stefanb@linux.ibm.com>,
        linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 02 May 2022 08:14:12 -0400
In-Reply-To: <ebe1f760-7831-e627-299a-c6a22f4bc5fb@linux.ibm.com>
References: <20220429112601.1421947-1-zohar@linux.ibm.com>
         <20220429112601.1421947-2-zohar@linux.ibm.com>
         <ebe1f760-7831-e627-299a-c6a22f4bc5fb@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: j8IYKQPZ6a4c5SSoOJtipKxR-aDb3qDx
X-Proofpoint-ORIG-GUID: j8IYKQPZ6a4c5SSoOJtipKxR-aDb3qDx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_03,2022-05-02_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 impostorscore=0 adultscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 phishscore=0 suspectscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205020094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 2022-04-29 at 12:44 -0400, Stefan Berger wrote:
> 
> On 4/29/22 07:25, Mimi Zohar wrote:
> > Initially the 'd-ng' template field did not prefix the digest with either
> > "md5" or "sha1" hash algorithms.  Prior to being upstreamed this changed,
> > but the comments and documentation were not updated.  Fix the comments
> > and documentation.
> > 
> > Fixes: 4d7aeee73f53 ("ima: define new template ima-ng and template fields d-ng and n-ng")
> > Reported-by: Eric Biggers <ebiggers@kernel.org>
> > Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> > ---
> >   Documentation/security/IMA-templates.rst  | 3 +--
> >   security/integrity/ima/ima_template_lib.c | 8 +++++---
> >   2 files changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
> > index 1a91d92950a7..cab97f49971d 100644
> > --- a/Documentation/security/IMA-templates.rst
> > +++ b/Documentation/security/IMA-templates.rst
> > @@ -66,8 +66,7 @@ descriptors by adding their identifier to the format string
> >      calculated with the SHA1 or MD5 hash algorithm;
> >    - 'n': the name of the event (i.e. the file name), with size up to 255 bytes;
> >    - 'd-ng': the digest of the event, calculated with an arbitrary hash
> > -   algorithm (field format: [<hash algo>:]digest, where the digest
> > -   prefix is shown only if the hash algorithm is not SHA1 or MD5);
> 
> That seemed to be true for 'd'

And initially for d-ng before it was upstreamed.

> 
> > +   algorithm (field format: <hash algo>:digest);
> >    - 'd-modsig': the digest of the event without the appended modsig;
> >    - 'n-ng': the name of the event, without size limitations;
> >    - 'sig': the file signature, or the EVM portable signature if the file
> > diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
> > index 7155d17a3b75..e9d65f6fe2ae 100644
> > --- a/security/integrity/ima/ima_template_lib.c
> > +++ b/security/integrity/ima/ima_template_lib.c
> > @@ -271,9 +271,11 @@ static int ima_eventdigest_init_common(const u8 *digest, u32 digestsize,
> >   	/*
> >   	 * digest formats:
> >   	 *  - DATA_FMT_DIGEST: digest
> > -	 *  - DATA_FMT_DIGEST_WITH_ALGO: [<hash algo>] + ':' + '\0' + digest,
> > -	 *    where <hash algo> is provided if the hash algorithm is not
> > -	 *    SHA1 or MD5
> > +	 *  - DATA_FMT_DIGEST_WITH_ALGO: <hash algo> + ':' + '\0' + digest, > +	 *
> > +	 *    where 'DATA_FMT_DIGEST' is the original digest format ('d')
> > +	 *      with a hash size limitation of 20 bytes,
> > +	 *    where <hash algo> is the hash_algo_name[] string.
> >   	 */
> >   	u8 buffer[CRYPTO_MAX_ALG_NAME + 2 + IMA_MAX_DIGEST_SIZE] = { 0 };
> >   	enum data_formats fmt = DATA_FMT_DIGEST;
> 
> Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>

Thank you, Stefan, for this and the other tags!

Mimi


