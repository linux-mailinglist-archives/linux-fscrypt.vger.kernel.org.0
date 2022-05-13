Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764A3526D88
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 May 2022 01:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiEMXf6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 May 2022 19:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiEMXf5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 May 2022 19:35:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07533327D3;
        Fri, 13 May 2022 16:26:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C6D761776;
        Fri, 13 May 2022 23:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65764C34113;
        Fri, 13 May 2022 23:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652484362;
        bh=VEmygfrCHywucMVMmgrfbT8EmWJSME+dfPPcFKelPLA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W1mydoCEeLrq4kdzHWmgByH7V3mGFRclrb3BjOdic8VR5jWGxXziLNZl0SgG/Tl4R
         9mI2Glau7zwC2K5uGiBtp4Mb1NBqhBoOlmdLy246xlRvDD0SrIU6ncQEahqS9ngvYc
         W5s/wrmQnTo/gTsbBuFXQpO6mslc2ElfmP1a/SW6UuuX+wy0lvQ8+1ByQn4ivkSx5V
         0pICcZ2hHbTDheOjaLYiKubqfttI2xjkLT/u+ZJcc6H8JZQNds/qfjjvD/3QHAJeAA
         KcIee4qgJEz2TwrQCq6cyAUdMy7FTlEbVeUE4r/RDvDM83chiTKERVQLLrpf9ErL/0
         A5HgYFOZWNbpg==
Date:   Fri, 13 May 2022 16:26:00 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Lukas Czerner <lczerner@redhat.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2 0/7] test_dummy_encryption fixes and cleanups
Message-ID: <Yn7pCEVAq0V4pcp7@sol.localdomain>
References: <20220501050857.538984-1-ebiggers@kernel.org>
 <Yn6zJR2peMo5hIcF@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yn6zJR2peMo5hIcF@mit.edu>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, May 13, 2022 at 03:36:05PM -0400, Theodore Ts'o wrote:
> On Sat, Apr 30, 2022 at 10:08:50PM -0700, Eric Biggers wrote:
> > We can either take all these patches through the fscrypt tree, or we can
> > take them in multiple cycles as follows:
> > 
> >     1. patch 1 via ext4, patch 2 via f2fs, patch 3-4 via fscrypt
> >     2. patch 5 via ext4, patch 6 via f2fs
> >     3. patch 7 via fscrypt
> > 
> > Ted and Jaegeuk, let me know what you prefer.
> 
> In order to avoid patch conflicts with other patch series, what I'd
> prefer is to take them in multiple cycles.  I can take patch #1 in my
> initial pull request to Linus, and then do a second pull request to
> Linus with patch #5 post -rc1 or -rc2 (depending on when patches #3
> and #4 hit Linus's tree).
> 
> Does that sound good?

That basically sounds fine.  I've just sent out v3 of this series, with the fix
for the memory leak in parse_apply_sb_mount_options() as its own patch.  That
patch can be applied now too, so you can take patches 1-2 of the v3 series in
your initial pull request.

- Eric
