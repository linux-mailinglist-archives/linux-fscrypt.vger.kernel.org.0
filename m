Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882E6358CD4
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Apr 2021 20:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhDHSlz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 14:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231676AbhDHSlz (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 14:41:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 931B361041;
        Thu,  8 Apr 2021 18:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617907303;
        bh=5jxMyiZzmrdbVj2R/hMXINSTVlVFTSuv6FtTMLMCzrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UvLY9saRFlWnGCSGe5CmmWf20W/g5leXLp1lWaaxVCPB+xQaaDsQGlplkBlKeZ+uR
         Ct3Fk06GmpRZqBuAuGk/CnltnzVT0j9FSLcsfS9DQ4vk3CkOVd1nRD/zwsLanvacoO
         8eo8CQi5Qm4OFckRg2MgqCB1sISD3MuAKqQyzwWgCWCMOr4orgB5OBGtENN1WkPnpA
         cAMM/Jecw9yWvtQ6yLO2//hMPpvFoFh4IlzORd+YQ4SmE5qkLyFakars6BdzM9iEWJ
         Z6GCRH88haQ0ntBjuTMrZZ1hBKZiQPFeGJIjPGTgYGtNKzDGtoHd4wkbHu3yzbRIZF
         70udcm//a39HA==
Date:   Thu, 8 Apr 2021 11:41:42 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 2/3] generic/574: corrupt btrfs merkle tree data
Message-ID: <YG9OZseq1nGv/wMk@sol.localdomain>
References: <cover.1617906318.git.boris@bur.io>
 <ca320cd0c8427458828cc36d5d5168bbe6b6bab2.1617906318.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca320cd0c8427458828cc36d5d5168bbe6b6bab2.1617906318.git.boris@bur.io>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Apr 08, 2021 at 11:30:12AM -0700, Boris Burkov wrote:
> 
> Note that there is a bit of a kludge here: since btrfs_corrupt_block
> doesn't handle streaming corruption bytes from stdin (I could change
> that, but it feels like overkill for this purpose), I just read the
> first corruption byte and duplicate it for the desired length. That is
> how the test is using the interface in practice, anyway.

If that's the problem, couldn't you just write the data to a temporary file?

- Eric
