Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0868A51294B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 28 Apr 2022 04:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiD1CHR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 27 Apr 2022 22:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiD1CHQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 27 Apr 2022 22:07:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCE15FF3D;
        Wed, 27 Apr 2022 19:04:03 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23S01jW6023389;
        Thu, 28 Apr 2022 02:03:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=v4DC5jk5MW0kmAL8NfEopkxW5+LAGdSMqLeMRUpLlxI=;
 b=RmyWBgSEjEROXKWcQlgvAZayB37v8sswxxdRHZUeBCIsHXJsktryRPjAqKvGmNI+06iE
 /TwFj9Nwych3tagggYm8satgE1IOiNSXRkjt/1czRs0Ek4Tqr/nroofW9YH7CuVLoPuW
 qQQAMEO4o5tVDFFY+Eo/7tKCewWE7vmODtTUeR9aFKwvWJjN/mfyGkfu2Rw7SVtwWAny
 /qUUBQ8F6P4vLYERNwdp+1r4V1wlEC1sXHWvyfEUzxvtd3HItxakbP6FOSfWqzojq/KX
 ReZPta5+wVIVmAjg+m6KFnHQv6psJGnjsUszqhnLk6zRg+679ufRu/AsZsfv62WoVvNI 5Q== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqg1a1qsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 02:03:56 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23S22aK4022680;
        Thu, 28 Apr 2022 02:03:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3fm938xpx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 02:03:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23S23qnU36045126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 02:03:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97EEBAE04D;
        Thu, 28 Apr 2022 02:03:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4BC6AE053;
        Thu, 28 Apr 2022 02:03:51 +0000 (GMT)
Received: from sig-9-65-70-226.ibm.com (unknown [9.65.70.226])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Apr 2022 02:03:51 +0000 (GMT)
Message-ID: <1f76429bfe89ee37a19f2d8ad0cf1a31ff9da798.camel@linux.ibm.com>
Subject: Re: [PATCH v7 2/5] ima: define a new template field named 'd-ngv2'
 and templates
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 27 Apr 2022 22:03:51 -0400
In-Reply-To: <YkyUdM5hmKf4noS7@gmail.com>
References: <20220325223824.310119-1-zohar@linux.ibm.com>
         <20220325223824.310119-3-zohar@linux.ibm.com> <YkyUdM5hmKf4noS7@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Jom3KH8WeVfajdKrCS7j0EwBuV8h46wP
X-Proofpoint-ORIG-GUID: Jom3KH8WeVfajdKrCS7j0EwBuV8h46wP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 spamscore=0 malwarescore=0
 impostorscore=0 phishscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280010
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 2022-04-05 at 19:11 +0000, Eric Biggers wrote:
> On Fri, Mar 25, 2022 at 06:38:21PM -0400, Mimi Zohar wrote:
> >  static int ima_eventdigest_init_common(const u8 *digest, u32 digestsize,
> > -				       u8 hash_algo,
> > +				       u8 digest_type, u8 hash_algo,
> >  				       struct ima_field_data *field_data)
> >  {
> >  	/*
> >  	 * digest formats:
> >  	 *  - DATA_FMT_DIGEST: digest
> >  	 *  - DATA_FMT_DIGEST_WITH_ALGO: [<hash algo>] + ':' + '\0' + digest,
> > +	 *  - DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO:
> > +	 *	[<digest type> + ':' + <hash algo>] + ':' + '\0' + digest,
> > +	 *    where <hash type> is either "ima" or "verity",
> >  	 *    where <hash algo> is provided if the hash algorithm is not
> >  	 *    SHA1 or MD5
> 
> This says both "hash type" and "digest type".  It should be one or the other.
> 
> The square brackets are meant to indicate that the part within it is optional,
> right?  Are they in the right place?  I don't see how this matches the code.
> There is also no explanation for why or when <digest type> is optional with
> DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO.

Agreed.

> 
> > +	if (digest_type < DIGEST_TYPE__LAST && hash_algo < HASH_ALGO__LAST) {
> > +		fmt = DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO;
> > +		offset += snprintf(buffer, DIGEST_TYPE_NAME_LEN_MAX +
> > +				   CRYPTO_MAX_ALG_NAME + 1, "%*s:%s",
> > +				   (int)strlen(digest_type_name[digest_type]),
> > +				   digest_type_name[digest_type],
> >  				   hash_algo_name[hash_algo]);
> >  		buffer[offset] = ':';
> >  		offset += 2;
> 
> There's no need to use %*s if the length argument is just going to be strlen().
> It should just use %s.

Using "%*s" prevents having a trailing NULL.

> 
> Also, this is not correct use of snprintf(), given that the string is
> unconditionally appended to at the offset which snprintf() returns.  So it is
> not providing buffer overflow protection.  It might as well just be:
> 
>                 offset += 1 + sprintf(buffer, "%s:%s:",
>                                       digest_type_name[digest_type],
>                                       hash_algo_name[hash_algo]);
> 
> and likewise for the other case:
> 
>                 offset += 1 + sprintf(buffer, "%s:", hash_algo_name[hash_algo]);
> 
> > +/*
> > + * This function writes the digest of an event (without size limit),
> > + * prefixed with both the hash type and algorithm.
> > + */
> > +int ima_eventdigest_ngv2_init(struct ima_event_data *event_data,
> > +			      struct ima_field_data *field_data)
> > +{
> > +	u8 *cur_digest = NULL, hash_algo = HASH_ALGO_SHA1;
> 
> Why is this defaulting to SHA-1?

Violation records contain 0's in the file hash and the template data
hash fields. Changing the default hash algorithm would result in larger
violation digests without any real benefit other than cosmetic.  Will
make the change anyway in the next version.

thanks,

Mimi

