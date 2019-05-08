Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D9317030
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 May 2019 06:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfEHEzS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 May 2019 00:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbfEHEzS (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 May 2019 00:55:18 -0400
Subject: Re: [GIT PULL] fscrypt updates for 5.2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557291317;
        bh=aX5ppYvNsRtV46AjBaYiU9S7VmouoF+KcrC4LfVo1Kg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=XvwkgeDn8BZJyVWdqv8iCUlc937tbSaZGSBL9Jp7aJrvhqg9xVWgZztXKI1DiswHX
         L1mOW+Tp67+C430G16lNPYOiLD65D3ri8LnHlBsSGo0oXAM5eDm3TU9bPWtXQXgfqM
         Xd4whlhu32wmFE+DQbARZJpv6C0021xcMgB12FtY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190507233042.GA28476@mit.edu>
References: <20190507233042.GA28476@mit.edu>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190507233042.GA28476@mit.edu>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git
 tags/fscrypt_for_linus
X-PR-Tracked-Commit-Id: 2c58d548f5706d085c4b009f6abb945220460632
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a9fbcd6728837268784439ad0b02ede2c024c516
Message-Id: <155729131767.10324.7522991759546968756.pr-tracker-bot@kernel.org>
Date:   Wed, 08 May 2019 04:55:17 +0000
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The pull request you sent on Tue, 7 May 2019 19:30:42 -0400:

> git://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git tags/fscrypt_for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a9fbcd6728837268784439ad0b02ede2c024c516

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
