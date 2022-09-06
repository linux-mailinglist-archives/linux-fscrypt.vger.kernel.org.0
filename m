Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53C4F5AF842
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Sep 2022 01:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiIFXKe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 6 Sep 2022 19:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIFXKc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 6 Sep 2022 19:10:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A986D8049F;
        Tue,  6 Sep 2022 16:10:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D830B61722;
        Tue,  6 Sep 2022 23:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96CAC433D6;
        Tue,  6 Sep 2022 23:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662505827;
        bh=ssAE8df16RSnZCUlghfDDxIN0Pvy8jb9xd98L97UimU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NjUvvHp10Eb2XtjuGXEUzfs2MxGVFniA+p+PzdQB1GltgXYQqI7ucr+edpsYmk5My
         stsSt6uWLrCBNsMTjVmKS0JW6GJQloG+/BeWvCN9FncdEqGRuROmX8TuAvexlu2L1A
         8SaGlGqTN80GFktGXlcRQ1M+CL9+/dv+XqOkfniqmzFiE17QWaJrutDvxk6miSO5+5
         DMlytrerMps47jAdPkGDiAL296mHvnPuvDa30f7inotcWYZrOCjyfjYq87MrF2EFXd
         QVagVQgWBnNHFIMhwoEzDNUeMYCw6PIaNEAtuJwgYJfR+8UF5h9qJj7eCfVaN6S/2D
         GBMkSjPHrZhBg==
Date:   Tue, 6 Sep 2022 16:10:25 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 00/20] btrfs: add fscrypt integration
Message-ID: <YxfTYSWgGJsKf4fX@quark>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <YxfLQzL9BYnxwaXQ@quark>
 <d1718c87-cec0-1796-8585-e89f28a8d3bd@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1718c87-cec0-1796-8585-e89f28a8d3bd@dorminy.me>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Sep 06, 2022 at 07:01:15PM -0400, Sweet Tea Dorminy wrote:
> 
> 
> On 9/6/22 18:35, Eric Biggers wrote:
> > On Mon, Sep 05, 2022 at 08:35:15PM -0400, Sweet Tea Dorminy wrote:
> > > This is a changeset adding encryption to btrfs.
> > 
> > What git tree and commit does this apply to?
> 
> https://github.com/kdave/btrfs-devel/; branch misc-next. Should apply
> cleanly to its current tip, 76ccdc004e12312ea056811d530043ff11d050c6 .

Patch 8 wasn't received by linux-fscrypt for some reason, any idea why?

$ b4 am cover.1662420176.git.sweettea-kernel@dorminy.me
Looking up https://lore.kernel.org/linux-fscrypt/cover.1662420176.git.sweettea-kernel%40dorminy.me
Grabbing thread from lore.kernel.org/linux-fscrypt/cover.1662420176.git.sweettea-kernel%40dorminy.me/t.mbox.gz
Analyzing 22 messages in the thread
Checking attestation on all messages, may take a moment...
---
  [PATCH v2 1/20] fscrypt: expose fscrypt_nokey_name
  [PATCH v2 2/20] fscrypt: add flag allowing partially-encrypted directories
  [PATCH v2 3/20] fscrypt: add fscrypt_have_same_policy() to check inode compatibility
  [PATCH v2 4/20] fscrypt: allow fscrypt_generate_iv() to distinguish filenames
  [PATCH v2 5/20] fscrypt: add extent-based encryption
  [PATCH v2 6/20] fscrypt: document btrfs' fscrypt quirks.
  [PATCH v2 7/20] btrfs: store directory's encryption state
  ERROR: missing [8/20]!
  [PATCH v2 9/20] btrfs: setup fscrypt_names from dentrys using helper
  [PATCH v2 10/20] btrfs: factor a fscrypt_name matching method
  [PATCH v2 11/20] btrfs: disable various operations on encrypted inodes
  [PATCH v2 12/20] btrfs: start using fscrypt hooks.
  [PATCH v2 13/20] btrfs: add fscrypt_context items.
  [PATCH v2 14/20] btrfs: translate btrfs encryption flags and encrypted inode flag.
  [PATCH v2 15/20] btrfs: store a fscrypt extent context per normal file extent
  [PATCH v2 16/20] btrfs: Add new FEATURE_INCOMPAT_FSCRYPT feature flag.
  [PATCH v2 17/20] btrfs: reuse encrypted filename hash when possible.
  [PATCH v2 18/20] btrfs: adapt directory read and lookup to potentially encrypted filenames
  [PATCH v2 19/20] btrfs: encrypt normal file extent data if appropriate
  [PATCH v2 20/20] btrfs: implement fscrypt ioctls
