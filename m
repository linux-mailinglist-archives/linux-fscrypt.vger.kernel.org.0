Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB3868E4D6
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Feb 2023 01:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjBHAQp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 Feb 2023 19:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBHAQp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 Feb 2023 19:16:45 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1FA0330281;
        Tue,  7 Feb 2023 16:16:44 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 9851420C7E3C; Tue,  7 Feb 2023 16:16:43 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9851420C7E3C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675815403;
        bh=AZ+uoZUPPCrz5A3pE0qCEGIImkcUUqU1a5A+4MPDhOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HD6TakUTp+1ygsVn+yvO4lLksnYvK4/2liMIsQ1EhCDExaWVjFN4k2qVIYy0mjsg/
         W6SFhrCbMPxRNzeYqrneD1Ds4w00mBphmn6Nn+MlbbBsrnxOeVAzZUpoQfosVX8aJM
         PucybJQWryxPKwd9QDwzy0wbblP1xFcRKYTMKCrA=
Date:   Tue, 7 Feb 2023 16:16:43 -0800
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 13/16] ipe: enable support for fs-verity as a
 trust provider
Message-ID: <20230208001643.GB5107@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-14-git-send-email-wufan@linux.microsoft.com>
 <d62907da62b5e0b25c9d7bd4b3119a3d1827bd29.camel@huaweicloud.com>
 <20230201235031.GC9075@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <6ddfa7344d01b21a93d3909af9dac0ae5e2a79ee.camel@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ddfa7344d01b21a93d3909af9dac0ae5e2a79ee.camel@huaweicloud.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Feb 02, 2023 at 10:51:56AM +0100, Roberto Sassu wrote:
> On Wed, 2023-02-01 at 15:50 -0800, Fan Wu wrote:
> > On Tue, Jan 31, 2023 at 03:00:08PM +0100, Roberto Sassu wrote:
> > > On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > > > +/**
> > > > + * evaluate_fsv_sig_false - Analyze @ctx against a fsv sig false property.
> > > > + * @ctx: Supplies a pointer to the context being evaluated.
> > > > + * @p: Supplies a pointer to the property being evaluated.
> > > > + *
> > > > + * Return:
> > > > + * * true	- The current @ctx match the @p
> > > > + * * false	- The current @ctx doesn't match the @p
> > > > + */
> > > > +static bool evaluate_fsv_sig_false(const struct ipe_eval_ctx *const ctx,
> > > > +				   struct ipe_prop *p)
> > > > +{
> > > > +	return !ctx->ino ||
> > > > +	       !IS_VERITY(ctx->ino) ||
> > > > +	       !ctx->ipe_inode ||
> > > > +	       !ctx->ipe_inode->fs_verity_signed;
> > > > +}
> > > > +
> > > > +/**
> > > > + * evaluate_fsv_sig_true - Analyze @ctx against a fsv sig true property.
> > > > + * @ctx: Supplies a pointer to the context being evaluated.
> > > > + * @p: Supplies a pointer to the property being evaluated.
> > > > + *
> > > > + * Return:
> > > > + * * true - The current @ctx match the @p
> > > > + * * false - The current @ctx doesn't match the @p
> > > > + */
> > > > +static bool evaluate_fsv_sig_true(const struct ipe_eval_ctx *const ctx,
> > > > +				  struct ipe_prop *p)
> > > > +{
> > > > +	return ctx->ino &&
> > > > +	       IS_VERITY(ctx->ino) &&
> > > > +	       ctx->ipe_inode &&
> > > > +	       ctx->ipe_inode->fs_verity_signed;
> > > > +}
> > > 
> > > Isn't better to just define one function and prepend a ! in
> > > evaluate_property()?
> > Yes that's a better way to do it, I will take this idea.
> > 
> > > Not sure about the usefulness of the fsverity_signature= property as it
> > > is. I would at minimum allow to specify which keyring signatures are
> > > verified against, and ensure that the keyring has a restriction.
> > > 
> > > And maybe I would call fsverity_verify_signature() directly, after
> > > extending it to pass the desired keyring.
> > > 
> > Thanks for the suggestion.
> > For the initial version we only have the fsverity_signature property
> > to enable the policy can make decision based on the existence of the
> > signature. In the future we plan to add more properties to leverage
> > the remaining signature information so we can have the restrictions
> > you mentioned.
> 
> Uhm, these boolean properties feel like something is missing. In my
> opinion, one cannot accept just any signature, but should be able to
> specify the approved signers.
> 
> Roberto
> 
It does not accept any signature. For fsverity, the signature must be signed
by a key in the fsverity_keyring and similarly for dmverity the signature
must be signed by a key in the kernel builtin trusted keys or secondary keyring.
Therefore, the root of trust here is the system configured keyrings. 

The Boolean properties dmverity_signature and fsverity_signature are used
to differentiate the existence of signature because the signature is optional.
In a =TRUE case of these two properties, we know the digests are signed
by a key we can trust. And in a =FALSE case we know the file is from a unsigned
dmverity or fsverity, we could use a stricter policy to deny them. 

I agree that having the ability to restrict signers is better, but the feedback
from the last version was asking us to keep the initial version as simple
as possible. We definitely want to add more properties, but we will invest
more time in them once the initial version is accepted. 

-Fan

