Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97984F5486
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Apr 2022 07:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446614AbiDFFTW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 6 Apr 2022 01:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344753AbiDEVIr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 5 Apr 2022 17:08:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058785D5FF;
        Tue,  5 Apr 2022 13:31:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4D32B81FCB;
        Tue,  5 Apr 2022 20:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C26C385A0;
        Tue,  5 Apr 2022 20:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649190704;
        bh=hVvEkc+QO11ZHsYNIQDJIVc5jdlWet/kgSfgUtvbG/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jDpzZ/qW2fXYwFXtD8rfvPxLC+cmucdfq4k8q3Q/I1fZo1wrFvjpHT0dJgdgTXY2V
         /l74OHoZD0DmfyAw2zWm4AbqNBMr7NkZlonch0Y2jF6dNJiESmV2TaXEs3bOpvdqPb
         Btza7b5cdyfJujw+5H54+Mib4qI9nSSms2DVulBQPj3kw2JlckVyGGzHHDKKfM48nr
         3NZH4wSnHyxKGKXNjkIUyxa0sUF1NR0uYis2f+AymQVbn5lsguCWXKImCPzC338loS
         uM43snSY7JCMLQx53XPF5OLgULkGlybnsho4awM+fAuN7GffFU1mT1O+cSENJzTQEK
         C8ao2ZdEm0eBQ==
Date:   Tue, 5 Apr 2022 20:31:43 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 4/5] ima: support fs-verity file digest based version
 3 signatures
Message-ID: <YkynLz5ZuI3pnBk9@gmail.com>
References: <20220325223824.310119-1-zohar@linux.ibm.com>
 <20220325223824.310119-5-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325223824.310119-5-zohar@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

> The IMA policy defines "which" files are to be measured, verified, and/or
> audited.  For those files being verified, the policy rules indicate "how"
> the file should be verified.  For example to require a file be signed,
> the appraise policy rule must include the 'appraise_type' option.
> 
> 	appraise_type:= [imasig] | [imasig|modsig] | [sigv3]
>            where 'imasig' is the original or v2 signature (default),
>            where 'modsig' is an appended signature,
>            where 'sigv3' is the signature v3 format.
> 
> The policy rule must also indicate the type of signature, if not the IMA
> default, by specifying the digest type:
> 
> 	digest_type:= [verity]

I don't understand the above paragraph.  Should it say "type of digest" instead
of "type of signature"?  And what does specifying the digest type do, exactly?

> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> index 2e0c501ce9c8..acd17183ad8c 100644
> --- a/Documentation/ABI/testing/ima_policy
> +++ b/Documentation/ABI/testing/ima_policy
> @@ -47,7 +47,11 @@ Description:
>  			fgroup:= decimal value
>  		  lsm:  are LSM specific
>  		  option:
> -			appraise_type:= [imasig] [imasig|modsig]
> +			appraise_type:= [imasig] | [imasig|modsig] | [sigv3]
> +			    where 'imasig' is the original or v2 signature,
> +			    where 'modsig' is an appended signature,
> +			    where 'sigv3' is the IMA v3 signature.
> +

The documentation should explain the differences between the different signature
types, especially when a user would need to choose one or another.

> +
> +		Example of 'measure' and 'appraise' rules requiring fs-verity
> +		signatures (version 3) stored in security.ima xattr.
> +
> +		The 'measure' rule specifies the 'ima-sigv2' template option,
> +		which includes the indication of type of digest and the file
> +		signature in the measurement list.
> +
> +			measure func=BPRM_CHECK digest_type=verity \
> +				template=ima-sigv2

This says it requires version 3 signatures, however it then uses "ima-sigv2".

> @@ -183,13 +185,18 @@ enum hash_algo ima_get_hash_algo(const struct evm_ima_xattr_data *xattr_value,
>  		return ima_hash_algo;
>  
>  	switch (xattr_value->type) {
> +	case IMA_VERITY_DIGSIG:
> +		sig = (typeof(sig))xattr_value;
> +		if (sig->version != 3 || xattr_len <= sizeof(*sig) ||
> +		    sig->hash_algo >= HASH_ALGO__LAST)
> +			return ima_hash_algo;
> +		return sig->hash_algo;

It looks like this is falling back to SHA-1 if the xattr is invalid:

	int __ro_after_init ima_hash_algo = HASH_ALGO_SHA1;

How about falling back to a more secure hash algorithm, or returning an error?

> +/*
> + * calc_file_id_hash - calculate the hash of the ima_file_id struct data
> + * @type: xattr type [enum evm_ima_xattr_type]
> + * @algo: hash algorithm [enum hash_algo]
> + * @digest: pointer to the digest to be hashed
> + * @hash: (out) pointer to the hash
> + *
> + * IMA signature version 3 disambiguates the data that is signed by
> + * indirectly signing the hash of the ima_file_id structure data.
> + *
> + * Signing the ima_file_id struct is currently only supported for
> + * IMA_VERITY_DIGSIG type xattrs.
> + *
> + * Return 0 on success, error code otherwise.
> + */
> +static int calc_file_id_hash(enum evm_ima_xattr_type type,
> +			     enum hash_algo algo, const u8 *digest,
> +			     struct ima_digest_data *hash)
> +{
> +	struct ima_file_id file_id = {
> +		.hash_type = IMA_VERITY_DIGSIG, .hash_algorithm = algo};
> +	uint unused = HASH_MAX_DIGESTSIZE - hash_digest_size[algo];

'uint' is unusual in kernel code; please use 'unsigned int' instead.

> @@ -1735,14 +1745,24 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  			break;
>  		case Opt_appraise_type:
>  			ima_log_string(ab, "appraise_type", args[0].from);
> -			if ((strcmp(args[0].from, "imasig")) == 0)
> +			if ((strcmp(args[0].from, "imasig")) == 0) {
>  				entry->flags |= IMA_DIGSIG_REQUIRED;
> -			else if (IS_ENABLED(CONFIG_IMA_APPRAISE_MODSIG) &&
> -				 strcmp(args[0].from, "imasig|modsig") == 0)
> +			} else if (strcmp(args[0].from, "sigv3") == 0) {
> +				/*
> +				 * Only fsverity supports sigv3 for now.
> +				 * No need to define a new flag.
> +				 */
> +				if (entry->flags & IMA_VERITY_REQUIRED)
> +					entry->flags |= IMA_DIGSIG_REQUIRED;
> +				else
> +					result = -EINVAL;
> +			} else if (IS_ENABLED(CONFIG_IMA_APPRAISE_MODSIG) &&
> +				 strcmp(args[0].from, "imasig|modsig") == 0) {
>  				entry->flags |= IMA_DIGSIG_REQUIRED |
>  						IMA_MODSIG_ALLOWED;
> -			else
> +			} else {
>  				result = -EINVAL;
> +			}

This appears to be assuming that the appraise_type option is given after
digest_type rather than befoore, as digest_type is what sets the
IMA_VERITY_REQUIRED flag.  Is this intentional?  Does the order of options
matter in IMA rules, and if so where are the ordering requirements documented?

Also, it looks like this is allowing appraise_type=imasig or
appraise_type=imasig|modsig in combination with digest_type=verity.  Is that
intentional?  What is the use case for these combinations?

>  /*
> - * signature format v2 - for using with asymmetric keys
> + * signature header format v2 - for using with asymmetric keys
> + *
> + * signature format:
> + * version 2: regular file data hash based signature
> + * version 3: struct ima_file_id data based signature
>   */
>  struct signature_v2_hdr {

Is this struct also used with version 3, despite having v2 in its name?
The comment is not clear.

- Eric
