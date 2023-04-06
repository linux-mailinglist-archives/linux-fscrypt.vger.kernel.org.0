Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543BA6DA0F4
	for <lists+linux-fscrypt@lfdr.de>; Thu,  6 Apr 2023 21:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240145AbjDFTUK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 6 Apr 2023 15:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238771AbjDFTUJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 6 Apr 2023 15:20:09 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E9552D43;
        Thu,  6 Apr 2023 12:20:08 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id EE920210DF13; Thu,  6 Apr 2023 12:20:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EE920210DF13
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1680808807;
        bh=g2HfS/ZMTKQZRzpItrngBvXapTBkgpdLZhq7xEnI4H8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gT19rQ5YUGAjAckjJCB/pAvlv7LMSA7W2eJCCUnDZLw6nymQQ7XKfe9na6VR9qCQe
         RTvhfiah+2SlCPK5wxIPIxi0dokTS2UAYdsPK9FZLDtRX+yqU7L0Q1iyPsSI+ylHdJ
         URlbou6GsI3R9TIJ2NKzT1KZK69XElJ/QWudJfqQ=
Date:   Thu, 6 Apr 2023 12:20:07 -0700
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 01/16] security: add ipe lsm
Message-ID: <20230406192007.GA19196@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-2-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhTtXC=HMUF8uak-29E__xLN2Kh_znn0xdRbm-GkgqBNiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTtXC=HMUF8uak-29E__xLN2Kh_znn0xdRbm-GkgqBNiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-17.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Mar 02, 2023 at 02:00:48PM -0500, Paul Moore wrote:
> On Mon, Jan 30, 2023 at 5:58???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 8a5c25c20d00..5e27e84763cc 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -10273,6 +10273,11 @@ T:     git git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
> >  F:     security/integrity/ima/
> >  F:     security/integrity/
> >
> > +INTEGRITY POLICY ENFORCEMENT (IPE)
> > +M:     Fan Wu <wufan@linux.microsoft.com>
> > +S:     Supported
> > +F:     security/ipe/
> 
> You should probably add a mailing list (L:) and source tree URL (T:)
> to the IPE entry.  You can use the LSM mailing list to start if you
> like, there are several LSMs that do that today, e.g. Smack, Landlock,
> etc.  As far as the source tree is concerned, probably the easiest
> option is a simple GitHub repo, but there are plenty of other choices
> too.
> 
> Both the mailing list and the source URLs can always be updated in the
> future so don't worry too much about being stuck with either long
> term.
> 
> --
> paul-moore.com

We do have a github repo, I will add that link in the next version.

-Fan
