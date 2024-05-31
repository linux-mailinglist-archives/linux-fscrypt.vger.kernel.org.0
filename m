Return-Path: <linux-fscrypt+bounces-296-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 099108D5D60
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 10:59:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACB4B28D690
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 08:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A59113D535;
	Fri, 31 May 2024 08:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MZXieieX"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26538182B9;
	Fri, 31 May 2024 08:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717145982; cv=none; b=QXC9K+AZycfDKUcoICAn/j0zbOGmpU8BPs8/Cbmok4W8yDywaGP5LXs8JstF6LT3q3k1k0SBsyAAFJ+OuN33+P2Mpqi4XPCwUIOYPmSUKTe4Wra4afQrNX3k+pACKrJM+OcVJhXbV2EotxGAyLba74Y67YFwtjPFwLK4xlTjKJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717145982; c=relaxed/simple;
	bh=qL4aK7Nv4BLtVwweFvln4rfwcgeW/ZE5139hyLjaifc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y772XCUzr7Pv876ANZjP8cbNTzjQdGqv2RrIUrSSw4rRA2+waZkULUiPjFzmSxjF9gTeWy34I47Q+A3uLElt4ABvYx7PULe9Q2ptdWQ0Y0Uo9zAjL2S++b50XhgVgYPtC6a9PWOGKTkQ6Uz0l7wn3+itG5LXp1BJjojnYXKgX34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MZXieieX; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717145980; x=1748681980;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qL4aK7Nv4BLtVwweFvln4rfwcgeW/ZE5139hyLjaifc=;
  b=MZXieieX8OjNO4y9s/8enO5FD+DFL7nGztSS2fqnQrCE/jm9INedTV8K
   zx/lS6pkSIQYDVQnbJT9bKEH8WZNhscXIBhJMRLlv0rKyOgyzUKR39hNv
   lp7NlBqFhz78LSx3PhJlu/2bFFhq+IwVOPsNPL9XhPyilRysUNBsjvDIy
   sdwv4fSlA70B/Gz07PrgkOmvlUQyg2pe0WsO3fXBduqnzEITpAWan61rC
   DX/DcyZ3veS5U5uVSRY9N5XuA+6gJXrw3EcrLXcWlQlaZ4pxdmVaxjClW
   j968PZAR8qLHWqZ32ESrK//o1Twc39TjW4HzP9TVgAU5U0f5oVJ0MUhqT
   w==;
X-CSE-ConnectionGUID: PmMduE2ySXusCyhOorfJ5w==
X-CSE-MsgGUID: 1fd1dWubTrWO7iFQDYDVig==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="13804224"
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="13804224"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 01:59:40 -0700
X-CSE-ConnectionGUID: rd4Zxb6zSaWfSpbUxkc8Yw==
X-CSE-MsgGUID: G3/cV4m8TRKqdlpaGmBSkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="73584850"
Received: from unknown (HELO 0610945e7d16) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 31 May 2024 01:59:35 -0700
Received: from kbuild by 0610945e7d16 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sCy6m-000Gp4-2b;
	Fri, 31 May 2024 08:59:32 +0000
Date: Fri, 31 May 2024 16:58:25 +0800
From: kernel test robot <lkp@intel.com>
To: Lizhi Xu <lizhi.xu@windriver.com>, ebiggers@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
	jaegeuk@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	lizhi.xu@windriver.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Subject: Re: [PATCH V2] ext4: add casefolded feature check before setup
 encrypted info
Message-ID: <202405311607.yQR7dozp-lkp@intel.com>
References: <20240531030740.1024475-1-lizhi.xu@windriver.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531030740.1024475-1-lizhi.xu@windriver.com>

Hi Lizhi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on tytso-ext4/dev]
[also build test WARNING on netfilter-nf/main linus/master v6.10-rc1 next-20240529]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Lizhi-Xu/ext4-add-casefolded-feature-check-before-setup-encrypted-info/20240531-111129
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
patch link:    https://lore.kernel.org/r/20240531030740.1024475-1-lizhi.xu%40windriver.com
patch subject: [PATCH V2] ext4: add casefolded feature check before setup encrypted info
config: riscv-defconfig (https://download.01.org/0day-ci/archive/20240531/202405311607.yQR7dozp-lkp@intel.com/config)
compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project bafda89a0944d947fc4b3b5663185e07a397ac30)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240531/202405311607.yQR7dozp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405311607.yQR7dozp-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from fs/ext4/ialloc.c:21:
   In file included from include/linux/buffer_head.h:12:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:8:
   In file included from include/linux/cacheflush.h:5:
   In file included from arch/riscv/include/asm/cacheflush.h:9:
   In file included from include/linux/mm.h:2208:
   include/linux/vmstat.h:522:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     522 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
>> fs/ext4/ialloc.c:986:7: warning: variable 'err' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
     986 |                 if (ext4_has_feature_casefold(inode->i_sb))
         |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ext4/ialloc.c:988:7: note: uninitialized use occurs here
     988 |                 if (err)
         |                     ^~~
   fs/ext4/ialloc.c:986:3: note: remove the 'if' if its condition is always true
     986 |                 if (ext4_has_feature_casefold(inode->i_sb))
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     987 |                         err = fscrypt_prepare_new_inode(dir, inode, &encrypt);
   fs/ext4/ialloc.c:939:15: note: initialize the variable 'err' to silence this warning
     939 |         int ret2, err;
         |                      ^
         |                       = 0
   2 warnings generated.


vim +986 fs/ext4/ialloc.c

   912	
   913	/*
   914	 * There are two policies for allocating an inode.  If the new inode is
   915	 * a directory, then a forward search is made for a block group with both
   916	 * free space and a low directory-to-inode ratio; if that fails, then of
   917	 * the groups with above-average free space, that group with the fewest
   918	 * directories already is chosen.
   919	 *
   920	 * For other inodes, search forward from the parent directory's block
   921	 * group to find a free inode.
   922	 */
   923	struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
   924				       handle_t *handle, struct inode *dir,
   925				       umode_t mode, const struct qstr *qstr,
   926				       __u32 goal, uid_t *owner, __u32 i_flags,
   927				       int handle_type, unsigned int line_no,
   928				       int nblocks)
   929	{
   930		struct super_block *sb;
   931		struct buffer_head *inode_bitmap_bh = NULL;
   932		struct buffer_head *group_desc_bh;
   933		ext4_group_t ngroups, group = 0;
   934		unsigned long ino = 0;
   935		struct inode *inode;
   936		struct ext4_group_desc *gdp = NULL;
   937		struct ext4_inode_info *ei;
   938		struct ext4_sb_info *sbi;
   939		int ret2, err;
   940		struct inode *ret;
   941		ext4_group_t i;
   942		ext4_group_t flex_group;
   943		struct ext4_group_info *grp = NULL;
   944		bool encrypt = false;
   945	
   946		/* Cannot create files in a deleted directory */
   947		if (!dir || !dir->i_nlink)
   948			return ERR_PTR(-EPERM);
   949	
   950		sb = dir->i_sb;
   951		sbi = EXT4_SB(sb);
   952	
   953		if (unlikely(ext4_forced_shutdown(sb)))
   954			return ERR_PTR(-EIO);
   955	
   956		ngroups = ext4_get_groups_count(sb);
   957		trace_ext4_request_inode(dir, mode);
   958		inode = new_inode(sb);
   959		if (!inode)
   960			return ERR_PTR(-ENOMEM);
   961		ei = EXT4_I(inode);
   962	
   963		/*
   964		 * Initialize owners and quota early so that we don't have to account
   965		 * for quota initialization worst case in standard inode creating
   966		 * transaction
   967		 */
   968		if (owner) {
   969			inode->i_mode = mode;
   970			i_uid_write(inode, owner[0]);
   971			i_gid_write(inode, owner[1]);
   972		} else if (test_opt(sb, GRPID)) {
   973			inode->i_mode = mode;
   974			inode_fsuid_set(inode, idmap);
   975			inode->i_gid = dir->i_gid;
   976		} else
   977			inode_init_owner(idmap, inode, dir, mode);
   978	
   979		if (ext4_has_feature_project(sb) &&
   980		    ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT))
   981			ei->i_projid = EXT4_I(dir)->i_projid;
   982		else
   983			ei->i_projid = make_kprojid(&init_user_ns, EXT4_DEF_PROJID);
   984	
   985		if (!(i_flags & EXT4_EA_INODE_FL)) {
 > 986			if (ext4_has_feature_casefold(inode->i_sb))
   987				err = fscrypt_prepare_new_inode(dir, inode, &encrypt);
   988			if (err)
   989				goto out;
   990		}
   991	
   992		err = dquot_initialize(inode);
   993		if (err)
   994			goto out;
   995	
   996		if (!handle && sbi->s_journal && !(i_flags & EXT4_EA_INODE_FL)) {
   997			ret2 = ext4_xattr_credits_for_new_inode(dir, mode, encrypt);
   998			if (ret2 < 0) {
   999				err = ret2;
  1000				goto out;
  1001			}
  1002			nblocks += ret2;
  1003		}
  1004	
  1005		if (!goal)
  1006			goal = sbi->s_inode_goal;
  1007	
  1008		if (goal && goal <= le32_to_cpu(sbi->s_es->s_inodes_count)) {
  1009			group = (goal - 1) / EXT4_INODES_PER_GROUP(sb);
  1010			ino = (goal - 1) % EXT4_INODES_PER_GROUP(sb);
  1011			ret2 = 0;
  1012			goto got_group;
  1013		}
  1014	
  1015		if (S_ISDIR(mode))
  1016			ret2 = find_group_orlov(sb, dir, &group, mode, qstr);
  1017		else
  1018			ret2 = find_group_other(sb, dir, &group, mode);
  1019	
  1020	got_group:
  1021		EXT4_I(dir)->i_last_alloc_group = group;
  1022		err = -ENOSPC;
  1023		if (ret2 == -1)
  1024			goto out;
  1025	
  1026		/*
  1027		 * Normally we will only go through one pass of this loop,
  1028		 * unless we get unlucky and it turns out the group we selected
  1029		 * had its last inode grabbed by someone else.
  1030		 */
  1031		for (i = 0; i < ngroups; i++, ino = 0) {
  1032			err = -EIO;
  1033	
  1034			gdp = ext4_get_group_desc(sb, group, &group_desc_bh);
  1035			if (!gdp)
  1036				goto out;
  1037	
  1038			/*
  1039			 * Check free inodes count before loading bitmap.
  1040			 */
  1041			if (ext4_free_inodes_count(sb, gdp) == 0)
  1042				goto next_group;
  1043	
  1044			if (!(sbi->s_mount_state & EXT4_FC_REPLAY)) {
  1045				grp = ext4_get_group_info(sb, group);
  1046				/*
  1047				 * Skip groups with already-known suspicious inode
  1048				 * tables
  1049				 */
  1050				if (!grp || EXT4_MB_GRP_IBITMAP_CORRUPT(grp))
  1051					goto next_group;
  1052			}
  1053	
  1054			brelse(inode_bitmap_bh);
  1055			inode_bitmap_bh = ext4_read_inode_bitmap(sb, group);
  1056			/* Skip groups with suspicious inode tables */
  1057			if (((!(sbi->s_mount_state & EXT4_FC_REPLAY))
  1058			     && EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) ||
  1059			    IS_ERR(inode_bitmap_bh)) {
  1060				inode_bitmap_bh = NULL;
  1061				goto next_group;
  1062			}
  1063	
  1064	repeat_in_this_group:
  1065			ret2 = find_inode_bit(sb, group, inode_bitmap_bh, &ino);
  1066			if (!ret2)
  1067				goto next_group;
  1068	
  1069			if (group == 0 && (ino + 1) < EXT4_FIRST_INO(sb)) {
  1070				ext4_error(sb, "reserved inode found cleared - "
  1071					   "inode=%lu", ino + 1);
  1072				ext4_mark_group_bitmap_corrupted(sb, group,
  1073						EXT4_GROUP_INFO_IBITMAP_CORRUPT);
  1074				goto next_group;
  1075			}
  1076	
  1077			if ((!(sbi->s_mount_state & EXT4_FC_REPLAY)) && !handle) {
  1078				BUG_ON(nblocks <= 0);
  1079				handle = __ext4_journal_start_sb(NULL, dir->i_sb,
  1080					 line_no, handle_type, nblocks, 0,
  1081					 ext4_trans_default_revoke_credits(sb));
  1082				if (IS_ERR(handle)) {
  1083					err = PTR_ERR(handle);
  1084					ext4_std_error(sb, err);
  1085					goto out;
  1086				}
  1087			}
  1088			BUFFER_TRACE(inode_bitmap_bh, "get_write_access");
  1089			err = ext4_journal_get_write_access(handle, sb, inode_bitmap_bh,
  1090							    EXT4_JTR_NONE);
  1091			if (err) {
  1092				ext4_std_error(sb, err);
  1093				goto out;
  1094			}
  1095			ext4_lock_group(sb, group);
  1096			ret2 = ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);
  1097			if (ret2) {
  1098				/* Someone already took the bit. Repeat the search
  1099				 * with lock held.
  1100				 */
  1101				ret2 = find_inode_bit(sb, group, inode_bitmap_bh, &ino);
  1102				if (ret2) {
  1103					ext4_set_bit(ino, inode_bitmap_bh->b_data);
  1104					ret2 = 0;
  1105				} else {
  1106					ret2 = 1; /* we didn't grab the inode */
  1107				}
  1108			}
  1109			ext4_unlock_group(sb, group);
  1110			ino++;		/* the inode bitmap is zero-based */
  1111			if (!ret2)
  1112				goto got; /* we grabbed the inode! */
  1113	
  1114			if (ino < EXT4_INODES_PER_GROUP(sb))
  1115				goto repeat_in_this_group;
  1116	next_group:
  1117			if (++group == ngroups)
  1118				group = 0;
  1119		}
  1120		err = -ENOSPC;
  1121		goto out;
  1122	
  1123	got:
  1124		BUFFER_TRACE(inode_bitmap_bh, "call ext4_handle_dirty_metadata");
  1125		err = ext4_handle_dirty_metadata(handle, NULL, inode_bitmap_bh);
  1126		if (err) {
  1127			ext4_std_error(sb, err);
  1128			goto out;
  1129		}
  1130	
  1131		BUFFER_TRACE(group_desc_bh, "get_write_access");
  1132		err = ext4_journal_get_write_access(handle, sb, group_desc_bh,
  1133						    EXT4_JTR_NONE);
  1134		if (err) {
  1135			ext4_std_error(sb, err);
  1136			goto out;
  1137		}
  1138	
  1139		/* We may have to initialize the block bitmap if it isn't already */
  1140		if (ext4_has_group_desc_csum(sb) &&
  1141		    gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
  1142			struct buffer_head *block_bitmap_bh;
  1143	
  1144			block_bitmap_bh = ext4_read_block_bitmap(sb, group);
  1145			if (IS_ERR(block_bitmap_bh)) {
  1146				err = PTR_ERR(block_bitmap_bh);
  1147				goto out;
  1148			}
  1149			BUFFER_TRACE(block_bitmap_bh, "get block bitmap access");
  1150			err = ext4_journal_get_write_access(handle, sb, block_bitmap_bh,
  1151							    EXT4_JTR_NONE);
  1152			if (err) {
  1153				brelse(block_bitmap_bh);
  1154				ext4_std_error(sb, err);
  1155				goto out;
  1156			}
  1157	
  1158			BUFFER_TRACE(block_bitmap_bh, "dirty block bitmap");
  1159			err = ext4_handle_dirty_metadata(handle, NULL, block_bitmap_bh);
  1160	
  1161			/* recheck and clear flag under lock if we still need to */
  1162			ext4_lock_group(sb, group);
  1163			if (ext4_has_group_desc_csum(sb) &&
  1164			    (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT))) {
  1165				gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
  1166				ext4_free_group_clusters_set(sb, gdp,
  1167					ext4_free_clusters_after_init(sb, group, gdp));
  1168				ext4_block_bitmap_csum_set(sb, gdp, block_bitmap_bh);
  1169				ext4_group_desc_csum_set(sb, group, gdp);
  1170			}
  1171			ext4_unlock_group(sb, group);
  1172			brelse(block_bitmap_bh);
  1173	
  1174			if (err) {
  1175				ext4_std_error(sb, err);
  1176				goto out;
  1177			}
  1178		}
  1179	
  1180		/* Update the relevant bg descriptor fields */
  1181		if (ext4_has_group_desc_csum(sb)) {
  1182			int free;
  1183			struct ext4_group_info *grp = NULL;
  1184	
  1185			if (!(sbi->s_mount_state & EXT4_FC_REPLAY)) {
  1186				grp = ext4_get_group_info(sb, group);
  1187				if (!grp) {
  1188					err = -EFSCORRUPTED;
  1189					goto out;
  1190				}
  1191				down_read(&grp->alloc_sem); /*
  1192							     * protect vs itable
  1193							     * lazyinit
  1194							     */
  1195			}
  1196			ext4_lock_group(sb, group); /* while we modify the bg desc */
  1197			free = EXT4_INODES_PER_GROUP(sb) -
  1198				ext4_itable_unused_count(sb, gdp);
  1199			if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
  1200				gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
  1201				free = 0;
  1202			}
  1203			/*
  1204			 * Check the relative inode number against the last used
  1205			 * relative inode number in this group. if it is greater
  1206			 * we need to update the bg_itable_unused count
  1207			 */
  1208			if (ino > free)
  1209				ext4_itable_unused_set(sb, gdp,
  1210						(EXT4_INODES_PER_GROUP(sb) - ino));
  1211			if (!(sbi->s_mount_state & EXT4_FC_REPLAY))
  1212				up_read(&grp->alloc_sem);
  1213		} else {
  1214			ext4_lock_group(sb, group);
  1215		}
  1216	
  1217		ext4_free_inodes_set(sb, gdp, ext4_free_inodes_count(sb, gdp) - 1);
  1218		if (S_ISDIR(mode)) {
  1219			ext4_used_dirs_set(sb, gdp, ext4_used_dirs_count(sb, gdp) + 1);
  1220			if (sbi->s_log_groups_per_flex) {
  1221				ext4_group_t f = ext4_flex_group(sbi, group);
  1222	
  1223				atomic_inc(&sbi_array_rcu_deref(sbi, s_flex_groups,
  1224								f)->used_dirs);
  1225			}
  1226		}
  1227		if (ext4_has_group_desc_csum(sb)) {
  1228			ext4_inode_bitmap_csum_set(sb, gdp, inode_bitmap_bh,
  1229						   EXT4_INODES_PER_GROUP(sb) / 8);
  1230			ext4_group_desc_csum_set(sb, group, gdp);
  1231		}
  1232		ext4_unlock_group(sb, group);
  1233	
  1234		BUFFER_TRACE(group_desc_bh, "call ext4_handle_dirty_metadata");
  1235		err = ext4_handle_dirty_metadata(handle, NULL, group_desc_bh);
  1236		if (err) {
  1237			ext4_std_error(sb, err);
  1238			goto out;
  1239		}
  1240	
  1241		percpu_counter_dec(&sbi->s_freeinodes_counter);
  1242		if (S_ISDIR(mode))
  1243			percpu_counter_inc(&sbi->s_dirs_counter);
  1244	
  1245		if (sbi->s_log_groups_per_flex) {
  1246			flex_group = ext4_flex_group(sbi, group);
  1247			atomic_dec(&sbi_array_rcu_deref(sbi, s_flex_groups,
  1248							flex_group)->free_inodes);
  1249		}
  1250	
  1251		inode->i_ino = ino + group * EXT4_INODES_PER_GROUP(sb);
  1252		/* This is the optimal IO size (for stat), not the fs block size */
  1253		inode->i_blocks = 0;
  1254		simple_inode_init_ts(inode);
  1255		ei->i_crtime = inode_get_mtime(inode);
  1256	
  1257		memset(ei->i_data, 0, sizeof(ei->i_data));
  1258		ei->i_dir_start_lookup = 0;
  1259		ei->i_disksize = 0;
  1260	
  1261		/* Don't inherit extent flag from directory, amongst others. */
  1262		ei->i_flags =
  1263			ext4_mask_flags(mode, EXT4_I(dir)->i_flags & EXT4_FL_INHERITED);
  1264		ei->i_flags |= i_flags;
  1265		ei->i_file_acl = 0;
  1266		ei->i_dtime = 0;
  1267		ei->i_block_group = group;
  1268		ei->i_last_alloc_group = ~0;
  1269	
  1270		ext4_set_inode_flags(inode, true);
  1271		if (IS_DIRSYNC(inode))
  1272			ext4_handle_sync(handle);
  1273		if (insert_inode_locked(inode) < 0) {
  1274			/*
  1275			 * Likely a bitmap corruption causing inode to be allocated
  1276			 * twice.
  1277			 */
  1278			err = -EIO;
  1279			ext4_error(sb, "failed to insert inode %lu: doubly allocated?",
  1280				   inode->i_ino);
  1281			ext4_mark_group_bitmap_corrupted(sb, group,
  1282						EXT4_GROUP_INFO_IBITMAP_CORRUPT);
  1283			goto out;
  1284		}
  1285		inode->i_generation = get_random_u32();
  1286	
  1287		/* Precompute checksum seed for inode metadata */
  1288		if (ext4_has_metadata_csum(sb)) {
  1289			__u32 csum;
  1290			__le32 inum = cpu_to_le32(inode->i_ino);
  1291			__le32 gen = cpu_to_le32(inode->i_generation);
  1292			csum = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)&inum,
  1293					   sizeof(inum));
  1294			ei->i_csum_seed = ext4_chksum(sbi, csum, (__u8 *)&gen,
  1295						      sizeof(gen));
  1296		}
  1297	
  1298		ext4_clear_state_flags(ei); /* Only relevant on 32-bit archs */
  1299		ext4_set_inode_state(inode, EXT4_STATE_NEW);
  1300	
  1301		ei->i_extra_isize = sbi->s_want_extra_isize;
  1302		ei->i_inline_off = 0;
  1303		if (ext4_has_feature_inline_data(sb) &&
  1304		    (!(ei->i_flags & EXT4_DAX_FL) || S_ISDIR(mode)))
  1305			ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
  1306		ret = inode;
  1307		err = dquot_alloc_inode(inode);
  1308		if (err)
  1309			goto fail_drop;
  1310	
  1311		/*
  1312		 * Since the encryption xattr will always be unique, create it first so
  1313		 * that it's less likely to end up in an external xattr block and
  1314		 * prevent its deduplication.
  1315		 */
  1316		if (encrypt) {
  1317			err = fscrypt_set_context(inode, handle);
  1318			if (err)
  1319				goto fail_free_drop;
  1320		}
  1321	
  1322		if (!(ei->i_flags & EXT4_EA_INODE_FL)) {
  1323			err = ext4_init_acl(handle, inode, dir);
  1324			if (err)
  1325				goto fail_free_drop;
  1326	
  1327			err = ext4_init_security(handle, inode, dir, qstr);
  1328			if (err)
  1329				goto fail_free_drop;
  1330		}
  1331	
  1332		if (ext4_has_feature_extents(sb)) {
  1333			/* set extent flag only for directory, file and normal symlink*/
  1334			if (S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode)) {
  1335				ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
  1336				ext4_ext_tree_init(handle, inode);
  1337			}
  1338		}
  1339	
  1340		if (ext4_handle_valid(handle)) {
  1341			ei->i_sync_tid = handle->h_transaction->t_tid;
  1342			ei->i_datasync_tid = handle->h_transaction->t_tid;
  1343		}
  1344	
  1345		err = ext4_mark_inode_dirty(handle, inode);
  1346		if (err) {
  1347			ext4_std_error(sb, err);
  1348			goto fail_free_drop;
  1349		}
  1350	
  1351		ext4_debug("allocating inode %lu\n", inode->i_ino);
  1352		trace_ext4_allocate_inode(inode, dir, mode);
  1353		brelse(inode_bitmap_bh);
  1354		return ret;
  1355	
  1356	fail_free_drop:
  1357		dquot_free_inode(inode);
  1358	fail_drop:
  1359		clear_nlink(inode);
  1360		unlock_new_inode(inode);
  1361	out:
  1362		dquot_drop(inode);
  1363		inode->i_flags |= S_NOQUOTA;
  1364		iput(inode);
  1365		brelse(inode_bitmap_bh);
  1366		return ERR_PTR(err);
  1367	}
  1368	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

