Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE8EEB4FA
	for <lists+linux-fscrypt@lfdr.de>; Thu, 31 Oct 2019 17:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbfJaQqO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 31 Oct 2019 12:46:14 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:35407 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728714AbfJaQqO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 31 Oct 2019 12:46:14 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-98.corp.google.com [104.133.0.98] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x9VGjo7m016231
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Oct 2019 12:45:51 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 6335E420456; Thu, 31 Oct 2019 12:45:50 -0400 (EDT)
Date:   Thu, 31 Oct 2019 12:45:50 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Douglas Anderson <dianders@chromium.org>,
        Gwendal Grignou <gwendal@chromium.org>,
        Ryo Hashimoto <hashimoto@chromium.org>, groeck@chromium.org,
        apronin@chromium.org, sukhomlinov@google.com,
        Chao Yu <chao@kernel.org>
Subject: Re: [PATCH v2] Revert "ext4 crypto: fix to check feature status
 before get policy"
Message-ID: <20191031164550.GF16197@mit.edu>
References: <20191030215138.224671-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030215138.224671-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 30, 2019 at 02:51:38PM -0700, Eric Biggers wrote:
> From: Douglas Anderson <dianders@chromium.org>
> 
> This reverts commit 0642ea2409f3 ("ext4 crypto: fix to check feature
> status before get policy").
> 
> The commit made a clear and documented ABI change that is not backward
> compatible.  There exists userspace code [1][2] that relied on the old
> behavior and is now broken.
> 
> While we could entertain the idea of updating the userspace code to
> handle the ABI change, it's my understanding that in general ABI
> changes that break userspace are frowned upon (to put it nicely).

The rule is that if someone complains, we have to revert.  Douglas's
email counts as a complaint, so we should revert.  That being said, if
ChromeOS (userspace) changes to using /sys/fs/ext4/features/encryption
to determine whether or not the kernel supports encryption, then we
can in the future change the error code to make things consistent with
f2fs.

This looks good, I'll pull it into ext4 git tree.

						- Ted
