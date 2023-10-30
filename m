Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1F57DC358
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Oct 2023 01:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236013AbjJ3XuL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 30 Oct 2023 19:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235998AbjJ3XuJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 30 Oct 2023 19:50:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCB6C6;
        Mon, 30 Oct 2023 16:50:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4769C4167D;
        Mon, 30 Oct 2023 23:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698709804;
        bh=YRuUm4bfW2EB4ANBzXvcekrGTyABOCWpea4WyLpA9kE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=tFLJlvO+xv7S4as4euBltdN0oU+rxy6zacIym/GuIP/H2Ou9f7/Xin0j/KPnPJwIz
         sj98p3Vldxet+2fsIyrhSOywkiOaxThF8vTr+BXLzLLBmVh8uNiqjftnwYcV+O0DLX
         TIaEIQVt4/zp1KKY4UQfRYf1MltOG/KUh+eU808ZFO2jxHiwQ/0nLV7OTykJqV2TBe
         5Q3wF7R2/yp6eKy5DtM7b5mfHSVKOnrDCfMots+XogV2XkSb30msQI2ZsQGCpQ2nFR
         Nad4sNGVVFWdgbMsGQjN4inlu8Ewj1HKkkMVxnsp/GolIbI83aqmHFAzc/iFQaJ5T4
         pQXgjpdUG096Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8140E00092;
        Mon, 30 Oct 2023 23:50:04 +0000 (UTC)
Subject: Re: [GIT PULL] fscrypt updates for 6.7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20231030040419.GA43439@sol.localdomain>
References: <20231030040419.GA43439@sol.localdomain>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231030040419.GA43439@sol.localdomain>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/fs/fscrypt/linux.git tags/fscrypt-for-linus
X-PR-Tracked-Commit-Id: 15baf55481de700f8c4494cddb80ec4f4575548b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8829687a4ac1d484639425a691da46f6e361aec1
Message-Id: <169870980481.17163.6617828174238746064.pr-tracker-bot@kernel.org>
Date:   Mon, 30 Oct 2023 23:50:04 +0000
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The pull request you sent on Sun, 29 Oct 2023 21:04:19 -0700:

> https://git.kernel.org/pub/scm/fs/fscrypt/linux.git tags/fscrypt-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8829687a4ac1d484639425a691da46f6e361aec1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
