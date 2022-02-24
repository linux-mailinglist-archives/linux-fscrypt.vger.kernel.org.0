Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9496B4C210D
	for <lists+linux-fscrypt@lfdr.de>; Thu, 24 Feb 2022 02:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiBXBcG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 23 Feb 2022 20:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiBXBcF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 23 Feb 2022 20:32:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E18365CB;
        Wed, 23 Feb 2022 17:31:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1595460FCE;
        Thu, 24 Feb 2022 01:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B24C340EF;
        Thu, 24 Feb 2022 01:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645665854;
        bh=eQfAZltdUG4mDqD4yPpgabYWAEQGMIeeu2UXiTgjl3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QVOThs1DJLpp6RKm2WBRauaEH8PdlgXau2pkVIP9BoUePiXZAswrcyc3PXFBbQikt
         2oDtpaFdnWG6hYqPJlHRvEAGOxkucDmBdsjdEEEl4TDyJ/Z4fh1eDueJSKU13Jdy7Z
         BAE0PxVMNxXPjnhAOM76bNuwBKoAXHF5p5gr1cyhLBdqcFqblu8khZO8Y4NsE79lpc
         cQ7nQQ4niDH79xmBJaLIgAk+trPJHBiMjLD0YDawtNOATJOUvgvyngxuAyWFqD1dkp
         mC6fTvwjyna6qMzaIgjSyEdM7doPBd0NG3N31GP1n9vDEzZOUJ6xqocB9B/MI97R1q
         MG91fUK1cZUfQ==
Date:   Wed, 23 Feb 2022 17:24:12 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 7/8] ima: support fs-verity file digest based version
 3 signatures
Message-ID: <YhbePM/BiRCzL3bn@sol.localdomain>
References: <20220211214310.119257-1-zohar@linux.ibm.com>
 <20220211214310.119257-8-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211214310.119257-8-zohar@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Feb 11, 2022 at 04:43:09PM -0500, Mimi Zohar wrote:
> Instead of calculating a regular file hash and verifying the signature
> stored in the 'security.ima' xattr against the calculated file hash, get
> fs-verity's file digest and verify the signature (version 3) stored in
> 'security.ima' against the digest.
> 
> The policy rule 'appraise_type=' option is extended to support 'sigv3',
> which is initiality limited to fs-verity.
> 
> The fs-verity 'appraise' rules are identified by the 'digest-type=verity'
> option and require the 'appraise_type=sigv3' option.  The following
> 'appraise' policy rule requires fsverity file digests.  (The rule may be
> constrained, for example based on a fsuuid or LSM label.)
> 
> Basic fs-verity policy rule example:
>   appraise func=BPRM_CHECK digest_type=verity appraise_type=sigv3
> 
> Lastly, for IMA to differentiate between the original IMA signature
> from an fs-verity signature a new 'xattr_type' named IMA_VERITY_DIGSIG
> is defined.

I'm having a hard time understanding this patch.  Can you please describe the
motivation for doing things, not just the things themselves, and make sure the
explanation is understandable to someone who isn't an IMA expert?

> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> index ff3c906738cb..508053b8dd0a 100644
> --- a/Documentation/ABI/testing/ima_policy
> +++ b/Documentation/ABI/testing/ima_policy
> @@ -47,7 +47,7 @@ Description:
>  			fgroup:= decimal value
>  		  lsm:  are LSM specific
>  		  option:
> -			appraise_type:= [imasig] [imasig|modsig]
> +			appraise_type:= [imasig] | [imasig|modsig] | [sigv3]
>  			appraise_flag:= [check_blacklist]
>  			Currently, blacklist check is only for files signed with appended
>  			signature.
> @@ -153,9 +153,27 @@ Description:
>  
>  			appraise func=SETXATTR_CHECK appraise_algos=sha256,sha384,sha512
>  
> -		Example of 'measure' rule requiring fs-verity's digests on a
> -		particular filesystem with indication of type of digest in
> -		the measurement list.
> +		Example of a 'measure' rule requiring fs-verity's digests
> +		with indication of type of digest in the measurement list.
>  
>  			measure func=FILE_CHECK digest_type=verity \
> -				fsuuid=... template=ima-ngv2
> +				template=ima-ngv2
> +
> +		Example of 'measure' and 'appraise' rules requiring fs-verity
> +		signatures (version 3) stored in security.ima xattr.
> +
> +		The 'measure' rule specifies the 'ima-sig' template option,
> +		which includes the file signature in the measurement list.
> +
> +			measure func=BPRM_CHECK digest_type=verity \
> +				template=ima-sig
> +
> +		The 'appraise' rule specifies the type and signature version
> +		(sigv3) required.
> +
> +			appraise func=BPRM_CHECK digest_type=verity \
> +				appraise_type=sigv3
> +
> +		All of these policy rules could, for example, be constrained
> +		either based on a filesystem's UUID (fsuuid) or based on LSM
> +		labels.

Is there documentation for what the appraise_type argument means, or does it
just need to be reverse engineered from the above example?

> + - 'sig': the file signature, based on either the file's/fsverity's digest[1],
> +   or the EVM portable signature if the file signature is not found;

This sentence doesn't make sense.  How can it be the file signature if the
"file signature is not found"?

> @@ -303,6 +321,12 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
>  	case EVM_IMA_XATTR_DIGSIG:
>  		set_bit(IMA_DIGSIG, &iint->atomic_flags);
>  
> +		if (iint->flags & (IMA_DIGSIG_REQUIRED | IMA_VERITY_REQUIRED)) {
> +			*cause = "verity-signature-required";
> +			*status = INTEGRITY_FAIL;
> +			break;
> +		}

Shouldn't this check whether *both* of these flags are set?

> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 28aca1f9633b..d3006cc22ab1 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -1311,6 +1311,12 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
>  	    !(entry->flags & IMA_MODSIG_ALLOWED))
>  		return false;
>  
> +	/* Ensure APPRAISE verity file implies a v3 signature */
> +	if (entry->action == APPRAISE &&
> +	    (entry->flags & IMA_VERITY_REQUIRED) &&
> +	    !(entry->flags & IMA_DIGSIG_REQUIRED))
> +		return false;

This comment doesn't seem to match the code.

> diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
> index d370fca04de4..ecbe61c53d40 100644
> --- a/security/integrity/ima/ima_template_lib.c
> +++ b/security/integrity/ima/ima_template_lib.c
> @@ -495,7 +495,8 @@ int ima_eventsig_init(struct ima_event_data *event_data,
>  {
>  	struct evm_ima_xattr_data *xattr_value = event_data->xattr_value;
>  
> -	if ((!xattr_value) || (xattr_value->type != EVM_IMA_XATTR_DIGSIG))
> +	if (!xattr_value ||
> +	    !(xattr_value->type & (EVM_IMA_XATTR_DIGSIG | IMA_VERITY_DIGSIG)))
>  		return ima_eventevmsig_init(event_data, field_data);

This is OR-ing together values that aren't bit flags.

- Eric
