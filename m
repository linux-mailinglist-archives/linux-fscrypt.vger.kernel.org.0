Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D3D68797F
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Feb 2023 10:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjBBJwt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Feb 2023 04:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjBBJws (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Feb 2023 04:52:48 -0500
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F23AE6;
        Thu,  2 Feb 2023 01:52:46 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4P6v542HL0z9xGYW;
        Thu,  2 Feb 2023 17:44:24 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwDXVwPJh9tj+jnpAA--.15060S2;
        Thu, 02 Feb 2023 10:52:21 +0100 (CET)
Message-ID: <6ddfa7344d01b21a93d3909af9dac0ae5e2a79ee.camel@huaweicloud.com>
Subject: Re: [RFC PATCH v9 13/16] ipe: enable support for fs-verity as a
 trust provider
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Fan Wu <wufan@linux.microsoft.com>
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
Date:   Thu, 02 Feb 2023 10:51:56 +0100
In-Reply-To: <20230201235031.GC9075@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
         <1675119451-23180-14-git-send-email-wufan@linux.microsoft.com>
         <d62907da62b5e0b25c9d7bd4b3119a3d1827bd29.camel@huaweicloud.com>
         <20230201235031.GC9075@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwDXVwPJh9tj+jnpAA--.15060S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF1Dtry3CFyxuFWkCr4fAFb_yoW5JryfpF
        WFkF48KrZ0qF17KF10y3W8Xw1akrWxKay7urn8uwn7Was5Zr9rtr1IyFWUWFn8CFy8ZryY
        qF42yF15Z3s8AFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZ18PUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAQBF1jj4hv0wAAsQ
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2023-02-01 at 15:50 -0800, Fan Wu wrote:
> On Tue, Jan 31, 2023 at 03:00:08PM +0100, Roberto Sassu wrote:
> > On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > > +/**
> > > + * evaluate_fsv_sig_false - Analyze @ctx against a fsv sig false property.
> > > + * @ctx: Supplies a pointer to the context being evaluated.
> > > + * @p: Supplies a pointer to the property being evaluated.
> > > + *
> > > + * Return:
> > > + * * true	- The current @ctx match the @p
> > > + * * false	- The current @ctx doesn't match the @p
> > > + */
> > > +static bool evaluate_fsv_sig_false(const struct ipe_eval_ctx *const ctx,
> > > +				   struct ipe_prop *p)
> > > +{
> > > +	return !ctx->ino ||
> > > +	       !IS_VERITY(ctx->ino) ||
> > > +	       !ctx->ipe_inode ||
> > > +	       !ctx->ipe_inode->fs_verity_signed;
> > > +}
> > > +
> > > +/**
> > > + * evaluate_fsv_sig_true - Analyze @ctx against a fsv sig true property.
> > > + * @ctx: Supplies a pointer to the context being evaluated.
> > > + * @p: Supplies a pointer to the property being evaluated.
> > > + *
> > > + * Return:
> > > + * * true - The current @ctx match the @p
> > > + * * false - The current @ctx doesn't match the @p
> > > + */
> > > +static bool evaluate_fsv_sig_true(const struct ipe_eval_ctx *const ctx,
> > > +				  struct ipe_prop *p)
> > > +{
> > > +	return ctx->ino &&
> > > +	       IS_VERITY(ctx->ino) &&
> > > +	       ctx->ipe_inode &&
> > > +	       ctx->ipe_inode->fs_verity_signed;
> > > +}
> > 
> > Isn't better to just define one function and prepend a ! in
> > evaluate_property()?
> Yes that's a better way to do it, I will take this idea.
> 
> > Not sure about the usefulness of the fsverity_signature= property as it
> > is. I would at minimum allow to specify which keyring signatures are
> > verified against, and ensure that the keyring has a restriction.
> > 
> > And maybe I would call fsverity_verify_signature() directly, after
> > extending it to pass the desired keyring.
> > 
> Thanks for the suggestion.
> For the initial version we only have the fsverity_signature property
> to enable the policy can make decision based on the existence of the
> signature. In the future we plan to add more properties to leverage
> the remaining signature information so we can have the restrictions
> you mentioned.

Uhm, these boolean properties feel like something is missing. In my
opinion, one cannot accept just any signature, but should be able to
specify the approved signers.

Roberto

> -Fan
> 
> > I would also split this patch in two, one for fsverity_digest= and one
> > for fsverity_signature=.
> > 
> > Roberto

