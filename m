Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D4168720C
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Feb 2023 00:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjBAXuf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Feb 2023 18:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBAXue (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Feb 2023 18:50:34 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13B3566019;
        Wed,  1 Feb 2023 15:50:32 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id BDF7320B74F7; Wed,  1 Feb 2023 15:50:31 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BDF7320B74F7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675295431;
        bh=6yV0Cqoz9tn6IGL+ncMwaFz1B8gSu5804ZHGEFQr3s8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S+HHLvneBOs983jxPXwKxG8Ph2gbl7utcF2Ufz7EqEkyzRxi0uNZ2Uhi2TPlunsH7
         1ieS+micucycavE6sDwdVEvun7q+gYVslSwV+HeWCv03Dt8ExY773zBQ3H5YxsIWJw
         7P7Hi30gEWl27nR9L6yS+TK4iPeuqcoOsLLO0oLU=
Date:   Wed, 1 Feb 2023 15:50:31 -0800
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
Message-ID: <20230201235031.GC9075@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-14-git-send-email-wufan@linux.microsoft.com>
 <d62907da62b5e0b25c9d7bd4b3119a3d1827bd29.camel@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d62907da62b5e0b25c9d7bd4b3119a3d1827bd29.camel@huaweicloud.com>
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

On Tue, Jan 31, 2023 at 03:00:08PM +0100, Roberto Sassu wrote:
> On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > +/**
> > + * evaluate_fsv_sig_false - Analyze @ctx against a fsv sig false property.
> > + * @ctx: Supplies a pointer to the context being evaluated.
> > + * @p: Supplies a pointer to the property being evaluated.
> > + *
> > + * Return:
> > + * * true	- The current @ctx match the @p
> > + * * false	- The current @ctx doesn't match the @p
> > + */
> > +static bool evaluate_fsv_sig_false(const struct ipe_eval_ctx *const ctx,
> > +				   struct ipe_prop *p)
> > +{
> > +	return !ctx->ino ||
> > +	       !IS_VERITY(ctx->ino) ||
> > +	       !ctx->ipe_inode ||
> > +	       !ctx->ipe_inode->fs_verity_signed;
> > +}
> > +
> > +/**
> > + * evaluate_fsv_sig_true - Analyze @ctx against a fsv sig true property.
> > + * @ctx: Supplies a pointer to the context being evaluated.
> > + * @p: Supplies a pointer to the property being evaluated.
> > + *
> > + * Return:
> > + * * true - The current @ctx match the @p
> > + * * false - The current @ctx doesn't match the @p
> > + */
> > +static bool evaluate_fsv_sig_true(const struct ipe_eval_ctx *const ctx,
> > +				  struct ipe_prop *p)
> > +{
> > +	return ctx->ino &&
> > +	       IS_VERITY(ctx->ino) &&
> > +	       ctx->ipe_inode &&
> > +	       ctx->ipe_inode->fs_verity_signed;
> > +}
> 
> Isn't better to just define one function and prepend a ! in
> evaluate_property()?
Yes that's a better way to do it, I will take this idea.

> 
> Not sure about the usefulness of the fsverity_signature= property as it
> is. I would at minimum allow to specify which keyring signatures are
> verified against, and ensure that the keyring has a restriction.
> 
> And maybe I would call fsverity_verify_signature() directly, after
> extending it to pass the desired keyring.
> 
Thanks for the suggestion.
For the initial version we only have the fsverity_signature property
to enable the policy can make decision based on the existence of the
signature. In the future we plan to add more properties to leverage
the remaining signature information so we can have the restrictions
you mentioned.

-Fan

> I would also split this patch in two, one for fsverity_digest= and one
> for fsverity_signature=.
> 
> Roberto
