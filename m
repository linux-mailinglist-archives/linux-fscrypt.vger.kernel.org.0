Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C80C2B1367
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Nov 2020 01:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgKMAn7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Nov 2020 19:43:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgKMAn7 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Nov 2020 19:43:59 -0500
Subject: Re: [GIT PULL] another fscrypt fix for 5.10-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605228238;
        bh=BIe5HMjS9gt50Hxj+EvtbJmyK6vmFdQ/47oHVfN9Wac=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=v4aVOxObp/Bh95+DWGWwHvPWYLKI4tS+miiHRyVUCTSXsFZh3G/gb8ZOkRRqtCo41
         xrm/mGmBFFzW8H42Ri1vam2cM2NS3jcU+hyfixzrtf7UMa06AnEFZFOWKWz+18D6Bm
         MLTqgGg0h0LsHGmUdJFJYaYlfABEtJXjGxHXDVSY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <X63CTrVsH3WD+xcE@sol.localdomain>
References: <X63CTrVsH3WD+xcE@sol.localdomain>
X-PR-Tracked-List-Id: <linux-ext4.vger.kernel.org>
X-PR-Tracked-Message-Id: <X63CTrVsH3WD+xcE@sol.localdomain>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git tags/fscrypt-for-linus
X-PR-Tracked-Commit-Id: d19d8d345eecd9247cbe6cbf27aef271bd88aba7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 585e5b17b92dead8a3aca4e3c9876fbca5f7e0ba
Message-Id: <160522823863.10618.11737091089665240139.pr-tracker-bot@kernel.org>
Date:   Fri, 13 Nov 2020 00:43:58 +0000
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Satya Tangirala <satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The pull request you sent on Thu, 12 Nov 2020 15:16:30 -0800:

> https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git tags/fscrypt-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/585e5b17b92dead8a3aca4e3c9876fbca5f7e0ba

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
