Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA3475457E
	for <lists+linux-fscrypt@lfdr.de>; Sat, 15 Jul 2023 01:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjGNX47 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 14 Jul 2023 19:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjGNX46 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 14 Jul 2023 19:56:58 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 317573A95;
        Fri, 14 Jul 2023 16:56:57 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 7335221C4688; Fri, 14 Jul 2023 16:56:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7335221C4688
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1689379016;
        bh=55GL66P8Iq71LDl/wSLZ+IYTZ6btVclWUBP4727ThRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AKVTgQCUWoa+NO1kegUiZiU3vjAzVsrbk+5FDPZI3It2c1vylgnJYSBa47ruMgJnL
         w6yL2PZSPw5z6/2js00CimaEgCQTc8kqGyDTHgJXT74S+x4epf9KEj8ajgO7MsuqPE
         O2sBiqkUBD047ZJkwQ81OnXZ7aDN1pjUo7X57ozQ=
Date:   Fri, 14 Jul 2023 16:56:56 -0700
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [PATCH RFC v10 5/17] ipe: introduce 'boot_verified' as a trust
  provider
Message-ID: <20230714235656.GD15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-6-git-send-email-wufan@linux.microsoft.com>
 <7b0f16fd49fb3490af1018eba986d0e4.paul@paul-moore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b0f16fd49fb3490af1018eba986d0e4.paul@paul-moore.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Jul 08, 2023 at 12:23:02AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > IPE is designed to provide system level trust guarantees, this usually
> > implies that trust starts from bootup with a hardware root of trust,
> > which validates the bootloader. After this, the bootloader verifies the
> > kernel and the initramfs.
> > 
> > As there's no currently supported integrity method for initramfs, and
> > it's typically already verified by the bootloader, introduce a property
> > that causes the first superblock to have an execution to be "pinned",
> > which is typically initramfs.
> > 
> > When the "pinned" device is unmounted, it will be "unpinned" and
> > `boot_verified` property will always evaluate to false afterward.
> > 
> > We use a pointer with a spin_lock to "pin" the device instead of rcu
> > because rcu synchronization may sleep, which is not allowed when
> > unmounting a device.
> > 
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  security/ipe/eval.c          | 72 +++++++++++++++++++++++++++++++++++-
> >  security/ipe/eval.h          |  2 +
> >  security/ipe/hooks.c         | 12 ++++++
> >  security/ipe/hooks.h         |  2 +
> >  security/ipe/ipe.c           |  1 +
> >  security/ipe/policy.h        |  2 +
> >  security/ipe/policy_parser.c | 37 +++++++++++++++++-
> >  7 files changed, 126 insertions(+), 2 deletions(-)
> 
> The compilation errors continue into this patch.
> 
Sorry again for the header file problem.

> > diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
> > index 27e5767480b0..28c14adfe6d2 100644
> > --- a/security/ipe/policy_parser.c
> > +++ b/security/ipe/policy_parser.c
> > @@ -265,6 +265,12 @@ static enum ipe_action_type parse_action(char *t)
> >  	return match_token(t, action_tokens, args);
> >  }
> >  
> > +static const match_table_t property_tokens = {
> > +	{__IPE_PROP_BOOT_VERIFIED_FALSE,	"boot_verified=FALSE"},
> > +	{__IPE_PROP_BOOT_VERIFIED_TRUE,		"boot_verified=TRUE"},
> > +	{__IPE_PROP_INVALID,			NULL}
> > +};
> > +
> >  /**
> >   * parse_property - Parse the property type given a token string.
> >   * @t: Supplies the token string to be parsed.
> > @@ -277,7 +283,36 @@ static enum ipe_action_type parse_action(char *t)
> >   */
> >  static int parse_property(char *t, struct ipe_rule *r)
> >  {
> > -	return -EBADMSG;
> > +	substring_t args[MAX_OPT_ARGS];
> > +	struct ipe_prop *p = NULL;
> > +	int rc = 0;
> > +	int token;
> > +
> > +	p = kzalloc(sizeof(*p), GFP_KERNEL);
> > +	if (!p)
> > +		return -ENOMEM;
> > +
> > +	token = match_token(t, property_tokens, args);
> > +
> > +	switch (token) {
> > +	case __IPE_PROP_BOOT_VERIFIED_FALSE:
> > +	case __IPE_PROP_BOOT_VERIFIED_TRUE:
> > +		p->type = token;
> > +		break;
> > +	case __IPE_PROP_INVALID:
> 
> You generally don't need to explicitly specify a case if the code
> immediately falls through to 'default'.
> 
Got it, I will remove this line.

> > +	default:
> > +		rc = -EBADMSG;
> > +		break;
> > +	}
> > +	if (rc)
> > +		goto err;
> > +	list_add_tail(&p->next, &r->props);
> > +
> > +out:
> > +	return rc;
> > +err:
> > +	kfree(p);
> > +	goto out;
> 
> Once again, don't use a goto when the jump destination simply does a
> return, do the return directly.
> 
Sure, I will replace the goto with return.

-Fan
> >  }
> >  
> >  /**
> > -- 
> > 2.25.1
> 
> --
> paul-moore.com
