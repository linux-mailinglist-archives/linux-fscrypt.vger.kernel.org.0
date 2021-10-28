Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C1E43D9FA
	for <lists+linux-fscrypt@lfdr.de>; Thu, 28 Oct 2021 05:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhJ1DvV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 27 Oct 2021 23:51:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229704AbhJ1DvT (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 27 Oct 2021 23:51:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F52960F22;
        Thu, 28 Oct 2021 03:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635392931;
        bh=4uaS2ebATc8X0cVmdWXxFMt9mK9HMe1yPqm7907dkQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dJNWLvWTkhLqS95oSEtp08mQ+7EP1niXdYf5r4ot0nMkvT0wpoI7zdkS4IsXRamZ9
         qy7a3CpWbsWboUogzIiKuCq3PIle2iM846NEKhcyyE1cA+DCiDd2obFCxCvO/qzuI2
         FkGxEdyxv6FSORSLBpWEOmHbTB81JbEor5oGC8r95lX9R6bGT/uwKYO1aIdF9jYjom
         jOoUYpCGdfe6M1f25SBHS8P/Suc7BgDrUG5cQpKRD63QPMqGxxpJGuh1qDQ8DQ6JJu
         qf2VyQZM6/nwFxHZ2nlG9Er8R2YjsdgWnYsidVZHtH0L5lqloiPJG6Qk1yyO4L7zfE
         7smMRVWc8v7ag==
Date:   Wed, 27 Oct 2021 20:48:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Deven Bowers <deven.desai@linux.microsoft.com>
Cc:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, tytso@mit.edu, paul@paul-moore.com,
        eparis@redhat.com, jmorris@namei.org, serge@hallyn.com,
        jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v7 12/16] fsverity|security: add security hooks to
 fsverity digest and signature
Message-ID: <YXodhzYto5BRxqYO@sol.localdomain>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
 <1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
 <YWcyYBuNppjrVOe2@gmail.com>
 <9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
 <YWngaVdvMyWBlITZ@gmail.com>
 <f027e3fa-2f70-0cdb-ac7b-255cee68edbb@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f027e3fa-2f70-0cdb-ac7b-255cee68edbb@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 26, 2021 at 12:03:53PM -0700, Deven Bowers wrote:
> > > The proposed LSM (IPE) of this series will be the only one to need
> > > this information at the  moment. IPE’s goal is to have provide
> > > trust-based access control. Trust and Integrity are tied together,
> > > as you cannot prove trust without proving integrity.
> > I think you mean authenticity, not integrity?
> I’ve heard a lot of people use these terms in overloaded ways.
> 
> If we’re working with the definition of authenticity being
> “the property that a resource was _actually_ sent/created by a
> party”, and integrity being “the property that a resource was not
> modified from a point of time”, then yes. Though the statement isn’t
> false, though, because you’d need to prove integrity in the process of
> proving authenticity.
> 
> If not, could you clarify what you mean by authenticity and integrity,
> so that we can use consistent definitions?

In cryptography, integrity normally means knowing whether data has been
non-maliciously changed, while authenticity means knowing whether data is from a
particular source, which implies knowing whether it has been changed at all
(whether maliciously or not).  Consider that there are "Message Authentication
Codes" (MACs) and "Authenticated Encryption", not "Message Integrity Codes" and
"Intact Encryption".

Unfortunately lots of people do overload "integrity" to mean authenticity, so
you're not alone.  But it's confusing, so if you're going to do that then please
make sure to clearly explain what you mean.

> > Also how does this differ from IMA?  I know that IMA doesn't support fs-verity
> > file hashes, but that could be changed.  Why not extend IMA to cover your use
> > case(s)?
> We looked at extending IMA to cover our requirements extensively the past
> year
> based on feedback the last time I posted these patches. We implemented a
> prototype that had half of our requirements, but found it resulted in a
> large change list that would result in a large amount of pain in respect
> to maintenance, in addition to other more architectural concerns about the
> implementation. We weren’t convinced it was the correct direction, for our
> needs.
> 
> There was a presentation done at LSS 2021 around this prototype done by my
> colleague, Fan, who authored this patch and implemented the aforementioned
> prototype.
> 
> In general, IMA provides a whole suite of amazing functionality when it
> comes to everything integrity, as the fs-verity documentation states
> itself:
> 
>    IMA specifies a system-wide policy that specifies which
>    files are hashed and what to do with those hashes, such
>    as log them, authenticate them, or add them to a
>    measurement list.
> 
> Instead, IPE provides a fine-tuned way to _only_ enforce an access control
> policy to these files based on the defined trust requirements in the policy,
> under various contexts, (you might have different requirements for what
> executes in a general purpose, versus loadable kernel modules, for example).
> It will never provide bother to log, measure, or revalidate these hashes
> because
> that’s not its purpose. This is why it belongs at the LSM layer instead of
> the
> integrity subsystem layer, as it is providing access control based on a
> policy,
> versus providing deep integrations with the actual integrity claim.
> 
> IPE is trying to be agnostic to how precisely “trust” is provided, as
> opposed to be deeply integrated into the mechanism that provides
> “trust”.

IMA doesn't require logging or "measuring" hashes, though.  Those are just some
of its supported features.  And I thought the IMA developers were planning to
add support for fs-verity hashes, and that it wouldn't require an entirely new
architecture to do so.

Anyway, while it does sound to me like you're duplicating IMA, I don't really
have a horse in this race, and I defer to the IMA developers on this.  I trust
that you've been engaging with them?  This patchset isn't even Cc'ed to
linux-integrity, so it's unclear that's been happening.

- Eric
