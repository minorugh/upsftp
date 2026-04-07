#!/usr/bin/perl
#########################################
## automakelist.pl
## auto update filelist.cvs for upsftp
## create 2026.02.16 by minoru yamada.
## 2026.04 upsftp/に移動、GH全体スキャン
#########################################
use strict;
use warnings;
use File::Find;
use File::Copy;
use POSIX qw(strftime);

my $gh        = "/home/minoru/Dropbox/GH";
my $list_file = "$gh/upsftp/filelist.cvs";
my $bak_file  = "$gh/upsftp/filelist.cvs.bak";

## 除外ディレクトリ（スペース区切り、配下も自動除外）
## Step2（スキャン対象外）とStep3（既存リストからの削除）の両方に適用される。
my $exclude = 'common d_kukai_test font icon img js tex2pdf topimg zc .git tmp';

## 除外ファイル名パターン（正規表現）
## Step2（スキャン）とStep3（削除チェック）の両方に適用される。
##
## 【書き方】
##   qr/パターン/  →  Perlの正規表現オブジェクト
##   $  →  文字列の末尾にマッチ（ファイル名の末尾で判定）
##
## 【1パターンの例】
##   my $exclude_files = qr/index_new\.html$/;
##     → "index_new.html" で終わるファイルを除外
##
## 【複数パターンは | で区切る】
##   my $exclude_files = qr/index_new\.html$|draft\.html$|_wip\.html$/;
##     → "index_new.html"、"draft.html"、"_wip.html" で終わるファイルを除外
##
## 【注意】ドット(.)は正規表現では「任意の1文字」を意味するため、
##         リテラルのドットは \. とエスケープすること。
my $exclude_files = qr/index_new\.html$/;

## -------------------------------------------------
## 実行前に filelist.cvs.bak へバックアップ
## -------------------------------------------------
if (-e $list_file) {
    copy($list_file, $bak_file) or die "Cannot backup $list_file: $!";
    print "Backup: $bak_file\n";
}

## -------------------------------------------------
## Step1: 既存リストを読み込む
##        key = 第一コンマ前、value = 行全体（変更しない）
## -------------------------------------------------
my %existing;
my @order;

if (-e $list_file) {
    open(my $fh, '<', $list_file) or die "Cannot open $list_file: $!";
    while (my $line = <$fh>) {
        chomp $line;
        next unless $line =~ /\S/;
        my ($key) = split(',', $line, 2);
        next unless defined $key && $key ne '';
        $existing{$key} = $line;
        push @order, $key;
    }
    close($fh);
}

## -------------------------------------------------
## Step2: GH全体の .html をスキャン
## -------------------------------------------------
my %found;
my %exclude_dirs = map { $_ => 1 } split(' ', $exclude);

File::Find::find({
    wanted => sub {
        my $abs = $File::Find::name;
        my $rel = $abs;
        $rel =~ s{^\Q$gh\E/}{};

        ## 除外ディレクトリはスキャンしない（配下も含めて）
        if (-d $abs) {
            my $top = (split '/', $rel)[0];
            if ($exclude_dirs{$top}) {
                $File::Find::prune = 1;
                return;
            }
        }

        return unless -f $abs && $abs =~ /\.html$/;

        ## キー形式：GH直下 → ./file、サブdir → dir/file
        my $key = ($rel =~ m{/}) ? $rel : "./$rel";

        return if $key =~ $exclude_files;

        $found{$key} = 1;
    },
    no_chdir => 1,
}, $gh);

## -------------------------------------------------
## Step3: リストにあるがローカルに実在しないファイル、
##        または除外ディレクトリ・除外ファイルパターンに
##        該当するエントリを削除する
## -------------------------------------------------
my $removed_count = 0;
my @new_order;

for my $key (@order) {
    my $path = $key;
    $path =~ s{^\./}{};
    my $abs  = "$gh/$path";
    my $top  = (split '/', $path)[0];  # 先頭ディレクトリ名

    ## 除外ディレクトリ配下のエントリは削除
    if ($exclude_dirs{$top}) {
        delete $existing{$key};
        print "Removed (exclude dir): $key\n";
        $removed_count++;
    ## 除外ファイルパターンに一致するエントリは削除
    } elsif ($key =~ $exclude_files) {
        delete $existing{$key};
        print "Removed (exclude file): $key\n";
        $removed_count++;
    ## ファイルが実在しない場合も削除
    } elsif (!-e $abs) {
        delete $existing{$key};
        print "Removed (not found): $key\n";
        $removed_count++;
    } else {
        push @new_order, $key;
    }
}

## -------------------------------------------------
## Step4: 未登録の .html を末尾に追加
## -------------------------------------------------
my $added_count = 0;

for my $key (sort keys %found) {
    unless (exists $existing{$key}) {
        $existing{$key} = "$key,";
        push @new_order, $key;
        print "Added: $key\n";
        $added_count++;
    }
}

## -------------------------------------------------
## Step5: 書き出し（元の順序 + 末尾に追加分、ソートしない）
## -------------------------------------------------
open(my $out, '>', $list_file) or die "Cannot open $list_file: $!";
for my $key (@new_order) {
    print $out "$existing{$key}\n";
}
close($out);

print "Done. Added: $added_count, Removed: $removed_count\n";
