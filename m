Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1764F54DB
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Apr 2022 07:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453963AbiDFFUV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 6 Apr 2022 01:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573648AbiDETaW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 5 Apr 2022 15:30:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6999BE9FD;
        Tue,  5 Apr 2022 12:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 798EBB81FA5;
        Tue,  5 Apr 2022 19:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFE8C385A0;
        Tue,  5 Apr 2022 19:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649186901;
        bh=pVw+p9ycf47WcueumebtNHtrMlhZvyHvueOH6HyIgxg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H7DrYXUcnOILq8iiKmQblcUhP12doiBbqszAS+75nlkzSSWvfMtpz0NrUXQomLzqR
         +wg1S6W0W4OJuwdK4xplboyrOrMqYJ1hjDXvV3JTxf4yj9KUf4MwuhApyFXwrL4xn6
         i4R8tvEldQQd2TvYxEoD+pz//7BsB48i7XGg/dKrEdcPabZkiFhUwA5zpL5zC/0wiO
         bKMul1zj1k7nTsCfMCNROi53v/8s0Vke0DQKca0hEBmzuYeY5HX7vF5sTupHXifJlm
         vl57JKzt34mqZiEE69FjJkXJ2iSEmX65i56DMdMV8DIGdyjbyb16VGLECbl5YPeTL1
         3+sLYUZjrxTuQ==
Date:   Tue, 5 Apr 2022 19:28:19 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/5] ima: permit fsverity's file digests in the IMA
 measurement list
Message-ID: <YkyYUzEK9Tw4TgL2@gmail.com>
References: <20220325223824.310119-1-zohar@linux.ibm.com>
 <20220325223824.310119-4-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325223824.310119-4-zohar@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Mar 25, 2022 at 06:38:22PM -0400, Mimi Zohar wrote:
> Permit fsverity's file digest (a hash of struct fsverity_digest) to be
> included in the IMA measurement list, based on the new measurement
> policy rule 'digest_type=verity' option.

"fsverity's file digest" *is* 'struct fsverity_digest', not a hash of it.
Did you mean to write 'struct fsverity_descriptor'?

> diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
> index 1a91d92950a7..2d4789dc7750 100644
> --- a/Documentation/security/IMA-templates.rst
> +++ b/Documentation/security/IMA-templates.rst
> @@ -68,6 +68,9 @@ descriptors by adding their identifier to the format string
>   - 'd-ng': the digest of the event, calculated with an arbitrary hash
>     algorithm (field format: [<hash algo>:]digest, where the digest
>     prefix is shown only if the hash algorithm is not SHA1 or MD5);
> + - 'd-ngv2': same as d-ng, but prefixed with the digest type.
> +    field format: [<digest type>:<hash algo>:]digest,
> +        where the digest type is either "ima" or "verity".

As in patch 2, it is not clear what the square brackets mean here.  Maybe they
mean that "<digest type>:<hash algo>:" is optional, but it is not explained when
they will be present and when they will not be present.

>   - 'd-modsig': the digest of the event without the appended modsig;
>   - 'n-ng': the name of the event, without size limitations;
>   - 'sig': the file signature, or the EVM portable signature if the file
> @@ -106,3 +109,8 @@ currently the following methods are supported:
>     the ``ima_template=`` parameter;
>   - register a new template descriptor with custom format through the kernel
>     command line parameter ``ima_template_fmt=``.
> +
> +
> +References
> +==========
> +[1] Documentation/filesystems/fsverity.rst

Is this meant to be a footnote?  There are no references to it above.

> @@ -242,14 +267,29 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
>  	 */
>  	i_version = inode_query_iversion(inode);
>  	hash.hdr.algo = algo;
> +	hash.hdr.length = hash_digest_size[algo];
>  
>  	/* Initialize hash digest to 0's in case of failure */
>  	memset(&hash.digest, 0, sizeof(hash.digest));
>  
> -	if (buf)
> +	if (buf) {
>  		result = ima_calc_buffer_hash(buf, size, &hash.hdr);
> -	else
> +	} else if (iint->flags & IMA_VERITY_REQUIRED) {
> +		result = ima_get_verity_digest(iint, &hash);
> +		switch (result) {
> +		case 0:
> +			break;
> +		case -ENODATA:
> +			audit_cause = "no-verity-digest";
> +			result = -EINVAL;
> +			break;
> +		default:
> +			audit_cause = "invalid-verity-digest";
> +			break;
> +		}
> +	} else {
>  		result = ima_calc_file_hash(file, &hash.hdr);
> +	}
>  
>  	if (result && result != -EBADF && result != -EINVAL)
>  		goto out;

The above code only calls ima_get_verity_digest() if 'buf' is non-NULL,
otherwise it calls ima_calc_buffer_hash().  Under what circumstances is 'buf'
non-NULL?  Does this imply that 'digest_type=verity' does not always use verity
digests, and if not, when are they used and when are they not used?

> +/*
> + * Make sure the policy rule and template format are in sync.
> + */
> +static void check_template_field(const struct ima_template_desc *template,
> +				 const char *field, const char *msg)
> +{
> +	int i;
> +
> +	for (i = 0; i < template->num_fields; i++)
> +		if (!strcmp(template->fields[i]->field_id, field))
> +			return;
> +
> +	pr_notice_once("%s", msg);
> +}

A better description for this function would be something like "Warn if the
template does not contain the given field."

> index daf49894fd7d..d42a01903f08 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -32,7 +32,7 @@
>  #define IMA_HASHED		0x00000200
>  
>  /* iint policy rule cache flags */
> -#define IMA_NONACTION_FLAGS	0xff000000
> +#define IMA_NONACTION_FLAGS	0xff800000
>  #define IMA_DIGSIG_REQUIRED	0x01000000
>  #define IMA_PERMIT_DIRECTIO	0x02000000
>  #define IMA_NEW_FILE		0x04000000
> @@ -40,6 +40,7 @@
>  #define IMA_FAIL_UNVERIFIABLE_SIGS	0x10000000
>  #define IMA_MODSIG_ALLOWED	0x20000000
>  #define IMA_CHECK_BLACKLIST	0x40000000
> +#define IMA_VERITY_REQUIRED	0x80000000

It is intentional that the new bit added to IMA_NONACTION_FLAGS is not the same
as IMA_VERITY_REQUIRED?

- Eric
