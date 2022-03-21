Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DD04E30EA
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Mar 2022 20:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352826AbiCUTu1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Mar 2022 15:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239684AbiCUTu0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Mar 2022 15:50:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D676E7CB35;
        Mon, 21 Mar 2022 12:49:00 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22LHqPGS002594;
        Mon, 21 Mar 2022 19:48:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=/32NuSvKToMX7b4xGjzfLvjI0xh2tfWsRPAXABKe04o=;
 b=Fu7SOryqbjHwCUsyVrP0hTkdR49q2LOZK9M0gZmcJGae+fExYOgbkAIGJMzc4/6Kyo9d
 kLao/FRpzeQceyBcaWzuLK+0KPhZ26VNyyVPyR4dL9/N0nG/XJn/Cl1gc/MBeiVQXQCF
 18wJ8Pn6PGVI3gnykf6WSRtQcRm7B8no+O0fXSEztxC03n15Fb/ar4vWZ4uIb1n6zCuf
 EnAMs8rCcXdNzLX5vP99PgKhJlrRkX9O6h7eTBQMsWUT4F8PXuUim/e/HfTKqKtkcyge
 b0Pa1S99y6QiIceZVOgU4D1xfhgMLpU8J2V0k6zCKHC3AVivXDMA0RcqzW1tEZ5iLZwO kQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3expy0mm72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 19:48:57 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LJmt4J017728;
        Mon, 21 Mar 2022 19:48:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3ew6t8m0b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 19:48:55 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LJmrsQ26608020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 19:48:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0356B42042;
        Mon, 21 Mar 2022 19:48:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DA8442041;
        Mon, 21 Mar 2022 19:48:52 +0000 (GMT)
Received: from sig-9-65-71-84.ibm.com (unknown [9.65.71.84])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 19:48:52 +0000 (GMT)
Message-ID: <31254e743b73a43f6f27679678318d0d8744a355.camel@linux.ibm.com>
Subject: Re: [PATCH v6 2/5] ima: define a new template field named 'd-ngv2'
 and templates
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Stefan Berger <stefanb@linux.ibm.com>,
        linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 21 Mar 2022 15:48:51 -0400
In-Reply-To: <b19eca12-3ae1-a8a5-fcfd-a22b5ee9319c@linux.ibm.com>
References: <20220318182151.100847-1-zohar@linux.ibm.com>
         <20220318182151.100847-3-zohar@linux.ibm.com>
         <b19eca12-3ae1-a8a5-fcfd-a22b5ee9319c@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hnFN2G3Havcxswh36i790sxpy2UPdC9m
X-Proofpoint-GUID: hnFN2G3Havcxswh36i790sxpy2UPdC9m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_08,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2022-03-21 at 08:53 -0400, Stefan Berger wrote:
> >   	/*
> >   	 * digest formats:
> >   	 *  - DATA_FMT_DIGEST: digest
> >   	 *  - DATA_FMT_DIGEST_WITH_ALGO: [<hash algo>] + ':' + '\0' + digest,
> > +	 *  - DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO:
> > +	 *	[<digest type> + ':' + <hash algo>] + ':' + '\0' + digest,
> > +	 *    where <hash type> is either "ima" or "verity",
> >   	 *    where <hash algo> is provided if the hash algorithm is not
> >   	 *    SHA1 or MD5
> >   	 */
> > -	u8 buffer[CRYPTO_MAX_ALG_NAME + 2 + IMA_MAX_DIGEST_SIZE] = { 0 };
> > +	u8 buffer[DIGEST_TYPE_MAXLEN + CRYPTO_MAX_ALG_NAME + 2 +
> > +		IMA_MAX_DIGEST_SIZE] = { 0 };
> 
> Should it not be DIGEST_TYPE_MAXLEN + 1 /* for ':' */ + 
> CRYPTO_MAX_ALG_NAME + ....

DIGEST_TYPE_MAXLEN is hard coded as 16.

> 
> >   	enum data_formats fmt = DATA_FMT_DIGEST;
> >   	u32 offset = 0;
> >   
> > -	if (hash_algo < HASH_ALGO__LAST) {
> > -		fmt = DATA_FMT_DIGEST_WITH_ALGO;
> > -		offset += snprintf(buffer, CRYPTO_MAX_ALG_NAME + 1, "%s",
> > +	if (digest_type < digest_type_size && hash_algo < HASH_ALGO__LAST) {
> 
> It's a bit difficult to see what the digest_type has to do with size...
> Maybe digest_type should be a enum and the comparison here should be 
> digest_type != DIGEST_TYPE_NONE or something like it..

digest_type_size is the size of the array.  It's defined as "static int
digest_type_size = ARRAY_SIZE(digest_type_name);", with the first
element as "ima".

> > +
> > +/*
> > + * This function writes the digest of an event (without size limit),
> > + * prefixed with both the hash type and algorithm.
> > + */
> > +int ima_eventdigest_ngv2_init(struct ima_event_data *event_data,
> > +			      struct ima_field_data *field_data)
> > +{
> > +	u8 *cur_digest = NULL, hash_algo = HASH_ALGO_SHA1;
> > +	u32 cur_digestsize = 0;
> > +	u8 digest_type = 0;
> 
> What does '0' mean? I think this should definitely be an enum or at 
> least #define.

The first element of the array is "ima".  Should I define two macros
similar to kernel_read_file_id and kernel_read_file_str for just two
strings?

thanks,

Mimi

