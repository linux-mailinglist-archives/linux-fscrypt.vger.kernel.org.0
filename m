Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1203D52CDF1
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 10:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbiESIKN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 May 2022 04:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235166AbiESIKM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 May 2022 04:10:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C5495DA5C
        for <linux-fscrypt@vger.kernel.org>; Thu, 19 May 2022 01:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652947811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B9p6EWWNDhVUAnJN064E2txfjCuXm3xARtuKmS8w/Nw=;
        b=H+/V2m2pc5IC/1Lt4m137eFIRUcixOn3WEDPpkBJmF0IQ7sUPy2kpFq625xYIgUdcwwVYn
        5qcWIYj0DzEALjqSefLCr40N8I+i0VX6YO2jsIwT0VeZRvk8kjuc5FMe3NgLPomttoi5Zu
        6uhlx247eC4VjceFpoYdSI8SccEkm84=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-ligSnExOPRitZsOsIxDvKw-1; Thu, 19 May 2022 04:10:09 -0400
X-MC-Unique: ligSnExOPRitZsOsIxDvKw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86D87803D4E;
        Thu, 19 May 2022 08:10:09 +0000 (UTC)
Received: from fedora (unknown [10.40.193.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 928497B64;
        Thu, 19 May 2022 08:10:08 +0000 (UTC)
Date:   Thu, 19 May 2022 10:10:06 +0200
From:   Lukas Czerner <lczerner@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [xfstests PATCH 0/2] update test_dummy_encryption testing in
 ext4/053
Message-ID: <20220519081006.inifyg57t3he4eyb@fedora>
References: <20220501051928.540278-1-ebiggers@kernel.org>
 <20220518141911.zg73znk2o2krxxwk@zlang-mailbox>
 <YoUu60S2AjP2fEOk@sol.localdomain>
 <20220518181607.fpzqmtnaky5jdiuw@zlang-mailbox>
 <YoVspJ6NUByHPn3r@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoVspJ6NUByHPn3r@sol.localdomain>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 18, 2022 at 03:01:08PM -0700, Eric Biggers wrote:
> Zorro, can you fix your email configuration?  Your emails have a
> Mail-Followup-To header that excludes you, so replying doesn't work correctly;
> I had to manually fix the recipients list.  If you're using mutt, you need to
> add 'set followup_to = no' to your muttrc.
> 
> On Thu, May 19, 2022 at 02:16:07AM +0800, Zorro Lang wrote:
> > > > 
> > > > And I saw some discussion under this patchset, and no any RVB, so I'm wondering
> > > > if you are still working/changing on it?
> > > > 
> > > 
> > > I might add a check for kernel version >= 5.19 in patch 1.  Otherwise I'm not
> > > planning any more changes.
> > 
> > Actually I don't think the kernel version check (in fstests) is a good method. Better
> > to check a behavior/feature directly likes those "_require_*" functions.
> > 
> > Why ext4/053 need >=5.12 or even >=5.19, what features restrict that? If some
> > features testing might break the garden image (.out file), we can refer to
> > _link_out_file(). Or even split this case to several small cases, make ext4/053
> > only test old stable behaviors. Then use other cases to test new features,
> > and use _require_$feature_you_test for them (avoid the kernel version
> > restriction).
> 
> This has been discussed earlier in this thread as well as on the patch that
> added ext4/053 originally.  ext4/053 has been gated on version >= 5.12 since the
> beginning.  Kernel version checks are certainly bad in general, but ext4/053 is
> a very nit-picky test intended to detect if anything changed, where a change
> does not necessarily mean a bug.  So maybe the kernel version check makes sense
> there.  Lukas, any thoughts about the issues you encountered when running
> ext4/053 on older kernels?

No I haven't encountered any problems, it works fine. I think kernel
version gating in this case it's adequate technical solution for the
problem we have. We want this test to be very nitpicky so that we really
do notice user facing mount behavior change on one hand, while we still
want to have some flexibility.

> 
> If you don't want a >= 5.19 version check for the test_dummy_encryption test
> case as well, then I'd rather treat the kernel patch
> "ext4: only allow test_dummy_encryption when supported" as a bug fix and
> backport it to the LTS kernels.  The patch is fixing the mount option to work
> the way it should have worked originally.  Either that or we just remove the
> test_dummy_encryption test case as Ted suggested.

Both is fine with me, but I would have a preference to treat it as a bug
fix and let the test fail on older kernels without the patch.

-Lukas

> 
> - Eric
> 

