Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A61C3D91D4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 28 Jul 2021 17:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbhG1P06 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jul 2021 11:26:58 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:47662 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235457AbhG1P05 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jul 2021 11:26:57 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 33F54222C2;
        Wed, 28 Jul 2021 15:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1627486015;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/IKirPWyi1/PVKNG3lgMDRtEACe3gGCTTacD60ken0c=;
        b=bmhQq2kF8az90ZhSfCNqr+jpGTAxs8wsnh9fmJtP9Z82CxztjaUNbZQzHzT9mjuCUKN/c+
        VpGagVn+JL3dEnN/skvdWSi8set8MBKEr00vrzT4agrZsNwEwswGnLNt7gf83pF9u40Ei4
        PhxkEKaQugzMnSzEE+Aa3Attqv5Z4Ns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1627486015;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/IKirPWyi1/PVKNG3lgMDRtEACe3gGCTTacD60ken0c=;
        b=ccU2IkwGibvFbepKZe/Nrum0+nvRiGUB4h9McV70N8XpYsPHnOCHVz81QCb4Lt0q6E1P2C
        RY5CCVCxSTYDAiCg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 2D0DAA3B87;
        Wed, 28 Jul 2021 15:26:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 46ACFDA8A7; Wed, 28 Jul 2021 17:24:10 +0200 (CEST)
Date:   Wed, 28 Jul 2021 17:24:10 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v6 0/3] btrfs: support fsverity
Message-ID: <20210728152410.GM5047@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1625083099.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1625083099.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 30, 2021 at 01:01:47PM -0700, Boris Burkov wrote:
> This patchset provides support for fsverity in btrfs.

I did one more pass and fixed issues pointed out by Eric and some other
minor style issues. Patchset has been moved from topic branch to
misc-next, please send separate patches or let me know if there are
trivial fixups needed. Thanks.
