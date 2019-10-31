Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 335B4EBAAD
	for <lists+linux-fscrypt@lfdr.de>; Fri,  1 Nov 2019 00:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbfJaXmD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 31 Oct 2019 19:42:03 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:40475 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726540AbfJaXmD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 31 Oct 2019 19:42:03 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-98.corp.google.com [104.133.0.98] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x9VNfsOk019099
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Oct 2019 19:41:55 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 6137C420456; Thu, 31 Oct 2019 19:41:54 -0400 (EDT)
Date:   Thu, 31 Oct 2019 19:41:54 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Satya Tangirala <satyat@google.com>,
        Paul Crowley <paulcrowley@google.com>,
        Paul Lawrence <paullawrence@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [e2fsprogs PATCH] Support the stable_inodes feature
Message-ID: <20191031234154.GI16197@mit.edu>
References: <20191021233043.36225-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021233043.36225-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 21, 2019 at 04:30:43PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Reserve the codepoint for EXT4_FEATURE_COMPAT_STABLE_INODES, allow it to
> be set and cleared, and teach resize2fs to forbid shrinking the
> filesystem if it is set.
> 
> This feature will allow the use of encryption policies where the inode
> number is included in the IVs (initialization vectors) for encryption,
> so data would be corrupted if the inodes were to be renumbered.
> 
> For more details, see the kernel patchset:
> https://lkml.kernel.org/linux-fsdevel/20191021230355.23136-1-ebiggers@kernel.org/T/#u
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, I've applied this as an AOSP cherry-pick.  (I've also
synchronized the upstream e2fsprogs git repo with the AOSP e2fsprogs
repo as of 43f6f573dd61 and updated go/aosp-e2fsprogs-reconciliation.
This commit is on the master branch, although the other AOSP commits,
being bug fixes, were landed first on the maint branch and then merged
into master.)

					- Ted
