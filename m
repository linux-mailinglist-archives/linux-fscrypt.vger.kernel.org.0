Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2962AF25E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Nov 2020 14:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgKKNkT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 Nov 2020 08:40:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727131AbgKKNjc (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 Nov 2020 08:39:32 -0500
Subject: Re: [GIT PULL] fscrypt fix for 5.10-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605101972;
        bh=St3T7u0v/pdG3Dve+wH090n95DpCzdR3wdreDU1jGWE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=r5u9FEgKdmht4lj9F2DNSrru89JsF/FHyj7RlSh3dQ/KUQpsNtM4DQj+bklK47W0K
         KJhD7q5tbeVjzO1YglJcqMKVfrQAOrplyMKQ3cQ7YFFNZ5crfHt5n64RSVea7XA68r
         iAbvCM8YIAEC14P3QIfZKrZtraR3b7KAOIkOYS7Q=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201109231151.GB853@sol.localdomain>
References: <20201109231151.GB853@sol.localdomain>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201109231151.GB853@sol.localdomain>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git tags/fscrypt-for-linus
X-PR-Tracked-Commit-Id: 92cfcd030e4b1de11a6b1edb0840e55c26332d31
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 52d1998d09af92d44ffce7454637dd3fd1afdc7d
Message-Id: <160510197238.25708.1718923078782898073.pr-tracker-bot@kernel.org>
Date:   Wed, 11 Nov 2020 13:39:32 +0000
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The pull request you sent on Mon, 9 Nov 2020 15:11:51 -0800:

> https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git tags/fscrypt-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/52d1998d09af92d44ffce7454637dd3fd1afdc7d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
