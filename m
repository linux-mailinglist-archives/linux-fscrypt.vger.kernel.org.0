Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73FD512957
	for <lists+linux-fscrypt@lfdr.de>; Thu, 28 Apr 2022 04:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241270AbiD1CId (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 27 Apr 2022 22:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241269AbiD1CIb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 27 Apr 2022 22:08:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBAA2FFE6;
        Wed, 27 Apr 2022 19:05:16 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23S01otC023562;
        Thu, 28 Apr 2022 02:05:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=78jiddQfNiso/uaWBxV6XXDGmOTg/ITHI9LdFP5hnmU=;
 b=kBbnUDRn99J+2VOpBYrERPwc6o5fVGg52cIiJf7Q4ytQsQCJPGkZ2wHyON73bIVZhDo8
 siRLiTO6AmCkP47fSXePqScQT2Eb2ooIbc5ahrdwh3oTCYWwKjE21RU1WJXPpZXYwquz
 SoKLjqS5U97csHKIpTowxjgMyDQEyro3BpbMnt9AQYYSZatzXihjFBjq98b4YeIJBVFt
 dunjNjQPJIBZbS17Ii83UveUSQhweSUZ5vM6rDC9z4Dc+QwPqWSseqrBzxVuK9ZRha/c
 iMaaXlwCTXz7/ezhH4m4LDXweC/fn/k7tE2YGh0nb6NtoCntw6AxYKn+UY5tSwowsgYS 9Q== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqg1a1reg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 02:05:13 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23S22b8m030119;
        Thu, 28 Apr 2022 02:05:11 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3fm938xqks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 02:05:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23S259IE36045218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 02:05:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C159A405B;
        Thu, 28 Apr 2022 02:05:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E6D2A4040;
        Thu, 28 Apr 2022 02:05:08 +0000 (GMT)
Received: from sig-9-65-70-226.ibm.com (unknown [9.65.70.226])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Apr 2022 02:05:08 +0000 (GMT)
Message-ID: <8b2763120ce3d20a00347aed40c3c190ddbf98a8.camel@linux.ibm.com>
Subject: Re: [PATCH v7 4/5] ima: support fs-verity file digest based version
 3 signatures
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 27 Apr 2022 22:05:07 -0400
In-Reply-To: <YkynLz5ZuI3pnBk9@gmail.com>
References: <20220325223824.310119-1-zohar@linux.ibm.com>
         <20220325223824.310119-5-zohar@linux.ibm.com> <YkynLz5ZuI3pnBk9@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FKnoGPSauXZ3bXHkJqRyNtOxdnOkDnq1
X-Proofpoint-ORIG-GUID: FKnoGPSauXZ3bXHkJqRyNtOxdnOkDnq1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
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

On Tue, 2022-04-05 at 20:31 +0000, Eric Biggers wrote:
> > The IMA policy defines "which" files are to be measured, verified, and/or
> > audited.  For those files being verified, the policy rules indicate "how"
> > the file should be verified.  For example to require a file be signed,
> > the appraise policy rule must include the 'appraise_type' option.
> > 
> > 	appraise_type:= [imasig] | [imasig|modsig] | [sigv3]
> >            where 'imasig' is the original or v2 signature (default),
> >            where 'modsig' is an appended signature,
> >            where 'sigv3' is the signature v3 format.
> > 
> > The policy rule must also indicate the type of signature, if not the IMA
> > default, by specifying the digest type:
> > 
> > 	digest_type:= [verity]
> 
> I don't understand the above paragraph.  Should it say "type of digest" instead
> of "type of signature"?  And what does specifying the digest type do, exactly?

Yes, the "type of digest".

Based on the type of digest, IMA either reads and calculates the file
hash or reads the fs-verity file hash.  Based on policy, the hash is
then included in the IMA measurement list, used to verify the file
signature, and/or added to the audit log.

> 
> > diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> > index 2e0c501ce9c8..acd17183ad8c 100644
> > --- a/Documentation/ABI/testing/ima_policy
> > +++ b/Documentation/ABI/testing/ima_policy
> > @@ -47,7 +47,11 @@ Description:
> >  			fgroup:= decimal value
> >  		  lsm:  are LSM specific
> >  		  option:
> > -			appraise_type:= [imasig] [imasig|modsig]
> > +			appraise_type:= [imasig] | [imasig|modsig] | [sigv3]
> > +			    where 'imasig' is the original or v2 signature,
> > +			    where 'modsig' is an appended signature,
> > +			    where 'sigv3' is the IMA v3 signature.
> > +
> 
> The documentation should explain the differences between the different signature
> types, especially when a user would need to choose one or another.

Agreed, it's confusing.  The source of that confusion is a result of
struct signature_v2_hdr name and the field named "version" in the
structure.  Here the signature_v2_hdr isn't changing, but a new field
"version" number is defined.
> 
> > +
> > +		Example of 'measure' and 'appraise' rules requiring fs-verity
> > +		signatures (version 3) stored in security.ima xattr.
> > +
> > +		The 'measure' rule specifies the 'ima-sigv2' template option,
> > +		which includes the indication of type of digest and the file
> > +		signature in the measurement list.
> > +
> > +			measure func=BPRM_CHECK digest_type=verity \
> > +				template=ima-sigv2
> 
> This says it requires version 3 signatures, however it then uses "ima-sigv2".

Agreed, it would make more sense to name the template "ima-sigv3" to
refer to the "version" field.

> 
> > @@ -183,13 +185,18 @@ enum hash_algo ima_get_hash_algo(const struct evm_ima_xattr_data *xattr_value,
> >  		return ima_hash_algo;
> >  
> >  	switch (xattr_value->type) {
> > +	case IMA_VERITY_DIGSIG:
> > +		sig = (typeof(sig))xattr_value;
> > +		if (sig->version != 3 || xattr_len <= sizeof(*sig) ||
> > +		    sig->hash_algo >= HASH_ALGO__LAST)
> > +			return ima_hash_algo;
> > +		return sig->hash_algo;
> 
> It looks like this is falling back to SHA-1 if the xattr is invalid:
> 
> 	int __ro_after_init ima_hash_algo = HASH_ALGO_SHA1;
> 
> How about falling back to a more secure hash algorithm, or returning an error?

ima_hash_algo is set to the configured default IMA hash algorithm in
init_ima().

> 
> > +/*
> > + * calc_file_id_hash - calculate the hash of the ima_file_id struct data
> > + * @type: xattr type [enum evm_ima_xattr_type]
> > + * @algo: hash algorithm [enum hash_algo]
> > + * @digest: pointer to the digest to be hashed
> > + * @hash: (out) pointer to the hash
> > + *
> > + * IMA signature version 3 disambiguates the data that is signed by
> > + * indirectly signing the hash of the ima_file_id structure data.
> > + *
> > + * Signing the ima_file_id struct is currently only supported for
> > + * IMA_VERITY_DIGSIG type xattrs.
> > + *
> > + * Return 0 on success, error code otherwise.
> > + */
> > +static int calc_file_id_hash(enum evm_ima_xattr_type type,
> > +			     enum hash_algo algo, const u8 *digest,
> > +			     struct ima_digest_data *hash)
> > +{
> > +	struct ima_file_id file_id = {
> > +		.hash_type = IMA_VERITY_DIGSIG, .hash_algorithm = algo};
> > +	uint unused = HASH_MAX_DIGESTSIZE - hash_digest_size[algo];
> 
> 'uint' is unusual in kernel code; please use 'unsigned int' instead.

Ok
> 
> > @@ -1735,14 +1745,24 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
> >  			break;
> >  		case Opt_appraise_type:
> >  			ima_log_string(ab, "appraise_type", args[0].from);
> > -			if ((strcmp(args[0].from, "imasig")) == 0)
> > +			if ((strcmp(args[0].from, "imasig")) == 0) {
> >  				entry->flags |= IMA_DIGSIG_REQUIRED;
> > -			else if (IS_ENABLED(CONFIG_IMA_APPRAISE_MODSIG) &&
> > -				 strcmp(args[0].from, "imasig|modsig") == 0)
> > +			} else if (strcmp(args[0].from, "sigv3") == 0) {
> > +				/*
> > +				 * Only fsverity supports sigv3 for now.
> > +				 * No need to define a new flag.
> > +				 */
> > +				if (entry->flags & IMA_VERITY_REQUIRED)
> > +					entry->flags |= IMA_DIGSIG_REQUIRED;
> > +				else
> > +					result = -EINVAL;
> > +			} else if (IS_ENABLED(CONFIG_IMA_APPRAISE_MODSIG) &&
> > +				 strcmp(args[0].from, "imasig|modsig") == 0) {
> >  				entry->flags |= IMA_DIGSIG_REQUIRED |
> >  						IMA_MODSIG_ALLOWED;
> > -			else
> > +			} else {
> >  				result = -EINVAL;
> > +			}
> 
> This appears to be assuming that the appraise_type option is given after
> digest_type rather than befoore, as digest_type is what sets the
> IMA_VERITY_REQUIRED flag.  Is this intentional?  Does the order of options
> matter in IMA rules, and if so where are the ordering requirements documented?
> 
> Also, it looks like this is allowing appraise_type=imasig or
> appraise_type=imasig|modsig in combination with digest_type=verity.  Is that
> intentional?  What is the use case for these combinations?
> 

All of your comments will be addressed in the next version, including
the ordering issue of "digest_type=verity" and "appraise_type=sigv3".

> >  /*
> > - * signature format v2 - for using with asymmetric keys
> > + * signature header format v2 - for using with asymmetric keys
> > + *
> > + * signature format:
> > + * version 2: regular file data hash based signature
> > + * version 3: struct ima_file_id data based signature
> >   */
> >  struct signature_v2_hdr {
> 
> Is this struct also used with version 3, despite having v2 in its name?
> The comment is not clear.

Agreed, it's confusing.  Too many versions.  This v2 refers to the
header format, while "version" in the signature_v2_hdr refers to the
signature format.

Mimi

