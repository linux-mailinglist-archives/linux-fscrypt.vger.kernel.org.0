Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96BD167BB8A
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Jan 2023 21:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbjAYUBk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 25 Jan 2023 15:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236093AbjAYUBi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 25 Jan 2023 15:01:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FE12A984
        for <linux-fscrypt@vger.kernel.org>; Wed, 25 Jan 2023 12:01:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 411EA61592
        for <linux-fscrypt@vger.kernel.org>; Wed, 25 Jan 2023 20:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA8FC433D2;
        Wed, 25 Jan 2023 20:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674676893;
        bh=myWWWUfa+USomgtlLWQAPpShELYL1rULYUvY5Mx89Cc=;
        h=Date:From:To:Cc:Subject:From;
        b=WgjBl4WwC9YLr9aiIUp58Y+c8r+2FAXfKH6a283SNCDQTNPev/0UeB5iMi083Ck/K
         /SP8Yd760bV4nGkQ8QnU6q2xqgMGZMu/yXTEYebm3dblnHdVAENW8vkMhOmNOznnty
         VlxwnGmIQTTvwSgKzK0BsSV0C2/MET38m4mG2xqmp/+zMi7VX9Be1lc8fSeiuP2Na9
         eRVKoYGuGLj9ur8agX6AnzVatD+Uccl3R+9GMxMNK9VzjiDmmUPOQGTcHyr4+KFSp9
         p/m+0mPALcXgMk9dpWbZLR8X8Kb1qlW4q5aSPTuvQWDJ1HcHT32k/ol4PG99g8Cf4N
         nKx+qEjz7saAg==
Date:   Wed, 25 Jan 2023 12:01:31 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     fsverity@lists.linux.dev
Cc:     linux-fscrypt@vger.kernel.org
Subject: [ANNOUNCE] Moving the fsverity-utils git repo
Message-ID: <Y9GKm+hcm70myZkr@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi,

I'm moving the fsverity-utils git repo from the following path:

	https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git

to the following path:

	https://git.kernel.org/pub/scm/fs/fsverity/fsverity-utils.git

This way, it's now owned by the "FSVerity FS Group" and isn't just in my
personal directory.  It's also now alongside the linux.git used for the kernel.

I'll keep the old repo around for a short time while I try to update the link in
a few places I know are using it.

- Eric
