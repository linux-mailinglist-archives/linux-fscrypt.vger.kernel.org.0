Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC27E1E087E
	for <lists+linux-fscrypt@lfdr.de>; Mon, 25 May 2020 10:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388487AbgEYIMN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 25 May 2020 04:12:13 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57558 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387668AbgEYIMN (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 May 2020 04:12:13 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 040F41979D741AC98205;
        Mon, 25 May 2020 16:12:11 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.211) with Microsoft SMTP Server (TLS) id 14.3.487.0; Mon, 25 May
 2020 16:12:08 +0800
Subject: Re: [PATCH 3/4] f2fs: rework filename handling
To:     Eric Biggers <ebiggers@kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
CC:     <linux-fscrypt@vger.kernel.org>,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>
References: <20200507075905.953777-1-ebiggers@kernel.org>
 <20200507075905.953777-4-ebiggers@kernel.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <9c18ded1-06cb-1187-1eac-5ba354eebee1@huawei.com>
Date:   Mon, 25 May 2020 16:12:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200507075905.953777-4-ebiggers@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2020/5/7 15:59, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Rework f2fs's handling of filenames to use a new 'struct f2fs_filename'.
> Similar to 'struct ext4_filename', this stores the usr_fname, disk_name,
> dirhash, crypto_buf, and casefolded name.  Some of these names can be
> NULL in some cases.  'struct f2fs_filename' differs from
> 'struct fscrypt_name' mainly in that the casefolded name is included.
> 
> For user-initiated directory operations like lookup() and create(),
> initialize the f2fs_filename by translating the corresponding
> fscrypt_name, then computing the dirhash and casefolded name if needed.
> 
> This makes the dirhash and casefolded name be cached for each syscall,
> so we don't have to recompute them repeatedly.  (Previously, f2fs
> computed the dirhash once per directory level, and the casefolded name
> once per directory block.)  This improves performance.
> 
> This rework also makes it much easier to correctly handle all
> combinations of normal, encrypted, casefolded, and encrypted+casefolded
> directories.  (The fourth isn't supported yet but is being worked on.)
> 
> The only other cases where an f2fs_filename gets initialized are for two
> filesystem-internal operations: (1) when converting an inline directory
> to a regular one, we grab the needed disk_name and hash from an existing
> f2fs_dir_entry; and (2) when roll-forward recovering a new dentry, we
> grab the needed disk_name from f2fs_inode::i_name and compute the hash.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
